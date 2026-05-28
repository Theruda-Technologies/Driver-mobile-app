library;

import '../../domain/entities/service_center.dart';

/// Parses garage availability from API payloads and builds bookable time slots.
///
/// Backend stores [startMinute]/[endMinute] as minutes-from-midnight and validates
/// appointments using UTC (see driver-garage-backend availability-booking.util).
/// Display times use those same minute values as local wall-clock hours.
class GarageAvailabilityParser {
  GarageAvailabilityParser._();

  static const _dayNames = <String>[
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  /// Accepts a JSON array or `{ slots: [...] }` / `{ data: [...] }`.
  static List<GarageAvailabilitySlot> parseSlots(dynamic raw) {
    final list = _extractList(raw);
    final slots = <GarageAvailabilitySlot>[];
    for (final item in list) {
      if (item is! Map) continue;
      final json = Map<String, dynamic>.from(item);
      final day = _normalizeDay(json['dayOfWeek']);
      var start = _resolveMinute(json, 'startMinute', 'startTime');
      var end = _resolveEndMinute(json);
      if (day == null) continue;
      if (_isFullDaySlot(start, end)) {
        start = 0;
        end = 1440;
      } else if (end <= start) {
        continue;
      }
      slots.add(
        GarageAvailabilitySlot(
          dayOfWeek: day,
          startMinute: start,
          endMinute: end,
        ),
      );
    }
    return slots;
  }

  /// From GET /services/nearby or GET /garages/{id}/profile only — never /garages/settings.
  static bool parseOnsiteEnabled(Map<String, dynamic> json) {
    final flag = json['onsiteServiceEnabled'];
    if (flag == true || flag == 1) return true;
    if (flag is String && flag.toLowerCase() == 'true') return true;
    // Profile payload may include embedded `setting.data` (same DB field as nearby).
    final setting = json['setting'];
    if (setting is Map) {
      final data = setting['data'];
      if (data is Map && data['onsiteServiceEnabled'] == true) return true;
    }
    return false;
  }

  static String? dayNameForDate(DateTime date) {
    if (date.weekday < 1 || date.weekday > 7) return null;
    return _dayNames[date.weekday - 1];
  }

  static bool isDateAvailable(DateTime date, List<GarageAvailabilitySlot> slots) {
    if (slots.isEmpty) return false;
    final day = dayNameForDate(date);
    if (day == null) return false;
    return slots.any(
      (s) =>
          s.dayOfWeek.toUpperCase() == day &&
          (s.endMinute > s.startMinute || _isFullDaySlot(s.startMinute, s.endMinute)),
    );
  }

  /// Bookable times for [date] (30-minute steps) respecting a service duration.
  ///
  /// If the backend slot is 08:00–18:00 and [durationMinutes]=60, the last
  /// selectable start time is 17:00 (because 17:00 + 60 <= 18:00).
  static List<({int hour, int minute})> timeSlotsForDate(
    DateTime date,
    List<GarageAvailabilitySlot> slots, {
    int stepMinutes = 30,
    int durationMinutes = 60,
  }) {
    if (slots.isEmpty) return const [];
    final day = dayNameForDate(date);
    if (day == null) return const [];

    final daySlots = slots
        .where(
          (s) =>
              s.dayOfWeek.toUpperCase() == day &&
              (s.endMinute > s.startMinute || _isFullDaySlot(s.startMinute, s.endMinute)),
        )
        .toList();
    if (daySlots.isEmpty) return const [];

    final times = <String, ({int hour, int minute})>{};
    for (final s in daySlots) {
      var minute = s.startMinute;
      while (minute + durationMinutes <= s.endMinute) {
        final h = minute ~/ 60;
        final m = minute % 60;
        times['$h:$m'] = (hour: h, minute: m);
        minute += stepMinutes;
      }
    }

    final out = times.values.toList()
      ..sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    return out;
  }

  /// Returns the widest availability window for [date] (start/end minutes).
  static ({int startMinute, int endMinute})? availabilityRangeForDate(
    DateTime date,
    List<GarageAvailabilitySlot> slots,
  ) {
    if (slots.isEmpty) return null;
    final day = dayNameForDate(date);
    if (day == null) return null;
    final daySlots = slots
        .where(
          (s) =>
              s.dayOfWeek.toUpperCase() == day &&
              (s.endMinute > s.startMinute || _isFullDaySlot(s.startMinute, s.endMinute)),
        )
        .toList();
    if (daySlots.isEmpty) return null;
    final start = daySlots.map((s) => s.startMinute).reduce((a, b) => a < b ? a : b);
    final end = daySlots.map((s) => s.endMinute).reduce((a, b) => a > b ? a : b);
    if (end <= start) return null;
    return (startMinute: start, endMinute: end);
  }

  /// UTC instant aligned with backend slot validation (wall-clock = slot minutes in UTC).
  static DateTime scheduledAtUtc({
    required DateTime date,
    required int hour,
    required int minute,
  }) {
    return DateTime.utc(date.year, date.month, date.day, hour, minute);
  }

  static List<dynamic> _extractList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map) {
      for (final key in ['slots', 'data', 'availabilitySlots', 'availability']) {
        final v = raw[key];
        if (v is List) return v;
      }
    }
    return const [];
  }

  static String? _normalizeDay(dynamic value) {
    if (value is int) {
      // Dart weekday: 1 = Monday … 7 = Sunday (matches backend DayOfWeek list).
      if (value >= 1 && value <= 7) return _dayNames[value - 1];
      // JS getUTCDay(): 0 = Sunday … 6 = Saturday.
      if (value >= 0 && value <= 6) {
        return _dayNames[value == 0 ? 6 : value - 1];
      }
    }
    final day = value?.toString().trim().toUpperCase();
    if (day == null || day.isEmpty) return null;
    if (_dayNames.contains(day)) return day;
    const short = {
      'MON': 'MONDAY',
      'TUE': 'TUESDAY',
      'WED': 'WEDNESDAY',
      'THU': 'THURSDAY',
      'FRI': 'FRIDAY',
      'SAT': 'SATURDAY',
      'SUN': 'SUNDAY',
    };
    return short[day];
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  /// Prefer numeric minutes; fall back to HH:mm when minute is 0 but time is set.
  static int _resolveMinute(
    Map<String, dynamic> json,
    String minuteKey,
    String timeKey,
  ) {
    if (json.containsKey(minuteKey) && json[minuteKey] != null) {
      final minute = _toInt(json[minuteKey]);
      if (minute > 0) return minute;
      final fromTime = _parseTimeToMinute(json[timeKey]);
      if (fromTime > 0) return fromTime;
      return minute;
    }
    return _parseTimeToMinute(json[timeKey]);
  }

  static int _resolveEndMinute(Map<String, dynamic> json) {
    final endTime = json['endTime']?.toString().trim();
    if (endTime == '24:00' || endTime == '24:00:00') return 1440;
    final end = _resolveMinute(json, 'endMinute', 'endTime');
    if (end >= 1440) return 1440;
    return end;
  }

  /// Backend allows endMinute up to 1440 (full day).
  static bool _isFullDaySlot(int start, int end) =>
      start == 0 && (end >= 1440 || end == 0);

  static int _parseTimeToMinute(dynamic time) {
    final s = time?.toString().trim();
    if (s == null || s.isEmpty) return 0;
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(s);
    if (match == null) return 0;
    final h = int.tryParse(match.group(1) ?? '');
    final m = int.tryParse(match.group(2) ?? '');
    if (h == null || m == null) return 0;
    if (h < 0 || h > 23 || m < 0 || m > 59) return 0;
    return h * 60 + m;
  }
}
