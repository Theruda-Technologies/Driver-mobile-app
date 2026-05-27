library;

import 'package:dio/dio.dart';

import '../../../../core/network/api_error_messages.dart';
import '../../domain/entities/service_center.dart';
import '../../domain/errors/service_locator_failure.dart';
import '../../domain/repositories/service_locator_repository.dart';
import '../datasources/service_locator_remote_datasource.dart';

class ServiceLocatorRepositoryImpl implements ServiceLocatorRepository {
  ServiceLocatorRepositoryImpl(this._remote);
  final ServiceLocatorRemoteDataSource _remote;

  @override
  Future<List<ServiceCenter>> getNearbyGarages({
    double? latitude,
    double? longitude,
  }) async {
    try {
      final list = await _remote.getNearby(
        latitude: latitude,
        longitude: longitude,
      );
      return list.map((m) => m.toEntity()).toList();
    } on DioException catch (e) {
      throw ServiceLocatorException(
        ApiErrorMessages.from(
          e,
          fallback: 'Unable to load nearby garages.',
        ),
      );
    } catch (e) {
      throw ServiceLocatorException('Unable to load nearby garages.');
    }
  }
}
