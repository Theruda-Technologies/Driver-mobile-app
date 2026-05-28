library;

import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../domain/entities/service_center.dart';
import '../models/garage_availability_parser.dart';
import '../models/garage_driver_profile_details.dart';

/// Loads garage profile for drivers (GET /garages/{id}/profile). Does not call /garages/settings.
abstract class GarageProfileRemoteDataSource {
  /// [seed] — nearby card JSON (keeps [onsiteServiceEnabled] from GET /services/nearby).
  Future<GarageDriverProfileDetails> fetchForDriver(
    String garageId, {
    Map<String, dynamic>? seed,
  });
}

class GarageProfileRemoteDataSourceImpl implements GarageProfileRemoteDataSource {
  GarageProfileRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<GarageDriverProfileDetails> fetchForDriver(
    String garageId, {
    Map<String, dynamic>? seed,
  }) async {
    try {
      final res = await _dio.get<dynamic>(ApiEndpoints.garageProfile(garageId));
      return _mergeWithSeed(_fromProfilePayload(res.data), seed);
    } on DioException catch (_) {
      return _mergeWithSeed(await _fetchComposed(garageId, seed: seed), seed);
    }
  }

  /// Matches driver-garage-backend garage profile + optional `setting.data`.
  GarageDriverProfileDetails _fromProfilePayload(dynamic raw) {
    final json = Map<String, dynamic>.from(raw as Map);
    final services = _parseServices(json['services']);
    final slots = GarageAvailabilityParser.parseSlots(
      json['availabilitySlots'] ?? json['availability'],
    );
    final rating = json['rating'];
    double? avg;
    int? total;
    if (rating is Map) {
      final a = rating['averageRating'];
      final t = rating['totalRatings'];
      if (a is num) avg = a.toDouble();
      if (t is num) total = t.toInt();
    }
    return GarageDriverProfileDetails(
      services: services,
      availabilitySlots: slots,
      onsiteServiceEnabled: _parseOnsiteFromProfile(json),
      averageRating: avg,
      totalRatings: total,
    );
  }

  Future<GarageDriverProfileDetails> _fetchComposed(
    String garageId, {
    Map<String, dynamic>? seed,
  }) async {
    final slotsRes = await _dio.get<dynamic>(
      ApiEndpoints.garageAvailabilitySlots(garageId),
    );
    final servicesRes = await _dio.get<dynamic>(
      ApiEndpoints.garageServices(garageId),
    );

    final slots = GarageAvailabilityParser.parseSlots(slotsRes.data);
    final services = _parseServices(servicesRes.data);

    double? avg;
    int? total;
    try {
      final ratingRes = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.garageRatingSummary(garageId),
      );
      final ratingData = ratingRes.data ?? const <String, dynamic>{};
      final a = ratingData['averageRating'];
      final t = ratingData['totalRatings'];
      if (a is num) avg = a.toDouble();
      if (t is num) total = t.toInt();
    } on DioException {
      // Ratings are optional for booking / hours.
    }

    final onsiteFromSeed =
        seed != null && GarageAvailabilityParser.parseOnsiteEnabled(seed);

    return GarageDriverProfileDetails(
      services: services,
      availabilitySlots: slots,
      onsiteServiceEnabled: onsiteFromSeed,
      averageRating: avg,
      totalRatings: total,
    );
  }

  static GarageDriverProfileDetails _mergeWithSeed(
    GarageDriverProfileDetails profile,
    Map<String, dynamic>? seed,
  ) {
    if (seed == null) return profile;
    final seedSlots = GarageAvailabilityParser.parseSlots(
      seed['availabilitySlots'] ?? seed['availability'],
    );
    final slots = profile.availabilitySlots.isNotEmpty
        ? profile.availabilitySlots
        : seedSlots;
    final onsite = profile.onsiteServiceEnabled ||
        GarageAvailabilityParser.parseOnsiteEnabled(seed);
    return GarageDriverProfileDetails(
      services: profile.services,
      availabilitySlots: slots,
      onsiteServiceEnabled: onsite,
      averageRating: profile.averageRating,
      totalRatings: profile.totalRatings,
    );
  }

  static bool _parseOnsiteFromProfile(Map<String, dynamic> json) =>
      GarageAvailabilityParser.parseOnsiteEnabled(json);

  static List<GarageOfferedService> _parseServices(dynamic raw) {
    if (raw is! List) return const [];
    final out = <GarageOfferedService>[];
    for (final e in raw) {
      if (e is String) {
        final n = e.trim();
        if (n.isNotEmpty) out.add(GarageOfferedService(id: '', name: n));
      } else if (e is Map) {
        final m = Map<String, dynamic>.from(e);
        final id = m['id']?.toString() ?? '';
        final name = (m['name'] ?? m['serviceName'])?.toString().trim() ?? '';
        if (name.isNotEmpty) out.add(GarageOfferedService(id: id, name: name));
      }
    }
    return out;
  }
}
