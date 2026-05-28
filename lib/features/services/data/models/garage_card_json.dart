library;

import '../../domain/entities/service_center.dart';
import '../../domain/utils/garage_open_status.dart';
import 'garage_availability_parser.dart';
import 'garage_driver_profile_details.dart';

/// Full nearby card JSON for profile merge (keeps name, distance, services, etc.).
Map<String, dynamic> garageSeedFromCenter(ServiceCenter center) {
  return {
    'id': center.id,
    'name': center.name,
    'subtitle': center.subtitle,
    'address': center.subtitle,
    'phone': center.phone,
    'latitude': center.latitude,
    'longitude': center.longitude,
    'distanceKm': center.distanceMiles,
    'distanceMiles': center.distanceMiles,
    'rating': center.rating,
    'reviewsCount': center.reviewsCount,
    'isRegistered': center.isRegistered,
    'isOpen': center.isOpen,
    if (center.onsiteServiceEnabled) 'onsiteServiceEnabled': true,
    if (center.services.isNotEmpty)
      'services': center.services
          .map((s) => <String, dynamic>{'id': s.id, 'name': s.name})
          .toList(),
    if (center.availabilitySlots.isNotEmpty)
      'availabilitySlots': center.availabilitySlots
          .map(
            (s) => <String, dynamic>{
              'dayOfWeek': s.dayOfWeek,
              'startMinute': s.startMinute,
              'endMinute': s.endMinute,
            },
          )
          .toList(),
  };
}

/// Parses GET /services/nearby body (array or wrapped list).
List<Map<String, dynamic>> parseNearbyGarageList(dynamic data) {
  List<dynamic> raw = const [];
  if (data is List) {
    raw = data;
  } else if (data is Map) {
    for (final key in ['data', 'garages', 'results', 'items']) {
      final v = data[key];
      if (v is List) {
        raw = v;
        break;
      }
    }
  }
  return raw
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .where((g) => (g['id']?.toString().trim() ?? '').isNotEmpty)
      .toList();
}

/// Normalizes nearby/profile JSON; nearby identity fields are never dropped.
Map<String, dynamic> mergeNearbyWithProfile(
  Map<String, dynamic> nearby,
  GarageDriverProfileDetails profile,
) {
  final seedSlots = GarageAvailabilityParser.parseSlots(
    nearby['availabilitySlots'] ?? nearby['availability'],
  );
  final profileSlots = profile.availabilitySlots;
  final slots = profileSlots.isNotEmpty ? profileSlots : seedSlots;

  final merged = finalizeGarageCardJson({
    ...nearby,
    if (profile.services.isNotEmpty)
      'services': profile.services
          .map((s) => <String, dynamic>{'id': s.id, 'name': s.name})
          .toList(),
    if (slots.isNotEmpty)
      'availabilitySlots': slots
          .map(
            (s) => <String, dynamic>{
              'dayOfWeek': s.dayOfWeek,
              'startMinute': s.startMinute,
              'endMinute': s.endMinute,
            },
          )
          .toList(),
    'onsiteServiceEnabled': GarageAvailabilityParser.parseOnsiteEnabled(nearby) ||
        profile.onsiteServiceEnabled,
    if (profile.averageRating != null) 'rating': profile.averageRating,
    if (profile.totalRatings != null) 'reviewsCount': profile.totalRatings,
    'isRegistered': nearby['isRegistered'] != false,
  });

  return _preserveNearbyIdentity(nearby, merged);
}

/// Applies open/closed, onsite, and slot normalization for list + map cards.
Map<String, dynamic> finalizeGarageCardJson(Map<String, dynamic> json) {
  final slots = GarageAvailabilityParser.parseSlots(
    json['availabilitySlots'] ?? json['availability'],
  );
  final onsite = GarageAvailabilityParser.parseOnsiteEnabled(json);

  return {
    ...json,
    if (slots.isNotEmpty)
      'availabilitySlots': slots
          .map(
            (s) => <String, dynamic>{
              'dayOfWeek': s.dayOfWeek,
              'startMinute': s.startMinute,
              'endMinute': s.endMinute,
            },
          )
          .toList(),
    'onsiteServiceEnabled': onsite,
    'isOpen': slots.isNotEmpty && GarageOpenStatus.isOpenNow(slots),
    'isRegistered': json['isRegistered'] != false,
  };
}

Map<String, dynamic> _preserveNearbyIdentity(
  Map<String, dynamic> nearby,
  Map<String, dynamic> merged,
) {
  final name = nearby['name'] ?? nearby['garageName'];
  final subtitle = nearby['subtitle'] ?? nearby['address'];
  final distance = nearby['distanceKm'] ?? nearby['distanceMiles'] ?? nearby['distance'];

  return {
    ...merged,
    if (nearby['id'] != null) 'id': nearby['id'],
    if (name != null && name.toString().trim().isNotEmpty) 'name': name,
    if (subtitle != null) 'subtitle': subtitle,
    if (nearby['phone'] != null) 'phone': nearby['phone'],
    if (nearby['latitude'] != null || nearby['lat'] != null)
      'latitude': nearby['latitude'] ?? nearby['lat'],
    if (nearby['longitude'] != null || nearby['lng'] != null)
      'longitude': nearby['longitude'] ?? nearby['lng'],
    if (distance != null) ...{
      'distanceKm': distance,
      'distanceMiles': distance,
    },
  };
}
