library;

import '../models/service_center_model.dart';

abstract class ServiceLocatorRemoteDataSource {
  Future<List<ServiceCenterModel>> getNearby({
    double? latitude,
    double? longitude,
  });

  /// Same enrichment as list cards: profile + nearby seed (onsite, hours).
  Future<ServiceCenterModel> enrichGarage(
    String garageId,
    Map<String, dynamic> seed,
  );
}
