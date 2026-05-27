library;

import '../../maintenance/domain/entities/vehicle_health.dart';
import '../../vehicles/domain/entities/vehicle.dart';

/// JSON body for RAG `vehicle_context` (matches Python `VehicleContextPayload`).
Map<String, dynamic>? buildAiVehicleContextPayload({
  Vehicle? vehicle,
  VehicleHealth? health,
}) {
  if (vehicle == null && health == null) return null;

  final out = <String, dynamic>{};
  if (vehicle != null) {
    out['vehicle'] = <String, dynamic>{
      'id': vehicle.id,
      'driverId': vehicle.driverId,
      'plateNumber': vehicle.plateNumber,
      'make': vehicle.make,
      'model': vehicle.model,
      'year': vehicle.year,
      'displayName': vehicle.displayName,
      if (vehicle.type != null) 'type': vehicle.type,
      if (vehicle.color != null) 'color': vehicle.color,
      if (vehicle.vin != null) 'vin': vehicle.vin,
      if (vehicle.mileage != null) 'mileage': vehicle.mileage,
      if (vehicle.fuelType != null) 'fuelType': vehicle.fuelType,
    };
  }
  if (health != null) {
    out['vehicle_health'] = <String, dynamic>{
      'overallPercent': health.overallPercent,
      if (health.summary != null && health.summary!.trim().isNotEmpty)
        'summary': health.summary!.trim(),
      'components': health.components
          .map(
            (c) => <String, dynamic>{
              'label': c.label,
              'percent': c.percent,
            },
          )
          .toList(),
    };
  }
  return out;
}
