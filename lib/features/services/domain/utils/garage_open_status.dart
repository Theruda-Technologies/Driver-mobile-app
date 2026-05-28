library;

import '../entities/service_center.dart';

/// Open/closed display vs bookability for a garage.
class GarageOpenStatus {
  GarageOpenStatus._();

  static const _days = <String>[
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  /// True when [when] falls inside any slot for today (local wall clock).
  static bool isOpenNow(
    List<GarageAvailabilitySlot> slots, [
    DateTime? when,
  ]) {
    if (slots.isEmpty) return false;
    final now = when ?? DateTime.now();
    if (now.weekday < 1 || now.weekday > 7) return false;
    final day = _days[now.weekday - 1];
    final minute = now.hour * 60 + now.minute;
    return slots.any((s) => _containsMinute(s, day, minute));
  }

  static bool _containsMinute(
    GarageAvailabilitySlot slot,
    String day,
    int minute,
  ) {
    if (slot.dayOfWeek.toUpperCase() != day) return false;
    final start = slot.startMinute;
    final end = slot.endMinute;
    if (end > start) {
      return minute >= start && minute < end;
    }
    // Overnight (e.g. 22:00–06:00) or wrap-around.
    return minute >= start || minute < end;
  }

  /// Garage has hours configured (or is on-platform) so booking can be offered.
  static bool acceptsBookings({
    required List<GarageAvailabilitySlot> slots,
    required bool isRegistered,
  }) {
    return slots.isNotEmpty || isRegistered;
  }
}
