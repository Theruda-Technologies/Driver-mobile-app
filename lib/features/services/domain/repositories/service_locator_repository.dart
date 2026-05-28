library;

import '../entities/service_center.dart';

abstract class ServiceLocatorRepository {
  /// Fetches nearby garages. [latitude] and [longitude] optional (e.g. from device).
  /// Returns empty list on API absence or non-fatal errors.
  Future<List<ServiceCenter>> getNearbyGarages({
    double? latitude,
    double? longitude,
  });

  /// Refreshes one garage from GET /garages/{id}/profile (+ nearby seed).
  Future<ServiceCenter> enrichGarageCenter(ServiceCenter center);
}
