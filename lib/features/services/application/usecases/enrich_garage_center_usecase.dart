library;

import '../../domain/entities/service_center.dart';
import '../../domain/repositories/service_locator_repository.dart';

/// Refreshes one garage from GET /garages/{id}/profile (detail / map selection).
class EnrichGarageCenterUseCase {
  EnrichGarageCenterUseCase(this._repository);

  final ServiceLocatorRepository _repository;

  Future<ServiceCenter> call(ServiceCenter center) =>
      _repository.enrichGarageCenter(center);
}
