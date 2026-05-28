library;

import '../../domain/entities/service_center.dart';

/// Driver-facing garage details (from profile API or composed endpoints).
class GarageDriverProfileDetails {
  const GarageDriverProfileDetails({
    required this.services,
    required this.availabilitySlots,
    required this.onsiteServiceEnabled,
    this.averageRating,
    this.totalRatings,
  });

  final List<GarageOfferedService> services;
  final List<GarageAvailabilitySlot> availabilitySlots;
  final bool onsiteServiceEnabled;
  final double? averageRating;
  final int? totalRatings;

  bool get hasSchedule => availabilitySlots.isNotEmpty;
}
