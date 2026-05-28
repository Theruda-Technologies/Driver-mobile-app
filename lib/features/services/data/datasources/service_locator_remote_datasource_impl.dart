library;

import 'package:dio/dio.dart';
import 'package:driver/features/services/data/datasources/service_locator_remote_datasource.dart';

import '../../../../core/constants/api_endpoints.dart';
import 'garage_profile_remote_datasource.dart';
import '../models/garage_availability_parser.dart';
import '../models/garage_card_json.dart';
import '../models/service_center_model.dart';

class ServiceLocatorRemoteDataSourceImpl
    implements ServiceLocatorRemoteDataSource {
  ServiceLocatorRemoteDataSourceImpl(
    this._dio, {
    GarageProfileRemoteDataSource? profileSource,
  }) : _profileSource = profileSource ?? GarageProfileRemoteDataSourceImpl(_dio);

  final Dio _dio;
  final GarageProfileRemoteDataSource _profileSource;

  @override
  Future<List<ServiceCenterModel>> getNearby({
    double? latitude,
    double? longitude,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (latitude != null) queryParams['lat'] = latitude;
      if (longitude != null) queryParams['lng'] = longitude;
      final res = await _dio.get<dynamic>(
        ApiEndpoints.nearbyServices,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );
      final garages = parseNearbyGarageList(res.data);
      final withHours = await Future.wait(
        garages.map(_ensureAvailabilityOnNearbyGarage),
      );
      return withHours
          .map(
            (g) => ServiceCenterModel.fromJson(finalizeGarageCardJson(g)),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 ||
          e.type == DioExceptionType.connectionError) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<ServiceCenterModel> enrichGarage(
    String garageId,
    Map<String, dynamic> seed,
  ) async {
    try {
      final profile = await _profileSource.fetchForDriver(garageId, seed: seed);
      return ServiceCenterModel.fromJson(
        mergeNearbyWithProfile(seed, profile),
      );
    } catch (_) {
      return ServiceCenterModel.fromJson(
        await _enrichFromAvailabilityOnly(seed, garageId),
      );
    }
  }

  /// Nearby may omit slots on older backends — load from availability API.
  Future<Map<String, dynamic>> _ensureAvailabilityOnNearbyGarage(
    Map<String, dynamic> garage,
  ) async {
    final existing = GarageAvailabilityParser.parseSlots(
      garage['availabilitySlots'] ?? garage['availability'],
    );
    if (existing.isNotEmpty) return garage;

    final id = garage['id']?.toString().trim() ?? '';
    if (id.isEmpty) return garage;

    try {
      final res = await _dio.get<dynamic>(
        ApiEndpoints.garageAvailabilitySlots(id),
      );
      final slots = GarageAvailabilityParser.parseSlots(res.data);
      if (slots.isEmpty) return garage;
      return {
        ...garage,
        'availabilitySlots': slots
            .map(
              (s) => <String, dynamic>{
                'dayOfWeek': s.dayOfWeek,
                'startMinute': s.startMinute,
                'endMinute': s.endMinute,
              },
            )
            .toList(),
      };
    } catch (_) {
      return garage;
    }
  }

  /// Adds hours from availability API when profile is unavailable.
  Future<Map<String, dynamic>> _enrichFromAvailabilityOnly(
    Map<String, dynamic> nearby,
    String garageId,
  ) async {
    try {
      final res = await _dio.get<dynamic>(
        ApiEndpoints.garageAvailabilitySlots(garageId),
      );
      final slots = GarageAvailabilityParser.parseSlots(res.data);
      if (slots.isEmpty) return finalizeGarageCardJson(nearby);
      return finalizeGarageCardJson({
        ...nearby,
        'availabilitySlots': slots
            .map(
              (s) => <String, dynamic>{
                'dayOfWeek': s.dayOfWeek,
                'startMinute': s.startMinute,
                'endMinute': s.endMinute,
              },
            )
            .toList(),
      });
    } catch (_) {
      return finalizeGarageCardJson(nearby);
    }
  }
}
