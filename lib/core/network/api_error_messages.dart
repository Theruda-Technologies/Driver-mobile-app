library;

import 'package:dio/dio.dart';

/// Converts API / network failures into short, user-safe snackbar copy.
class ApiErrorMessages {
  ApiErrorMessages._();

  static const defaultMessage = 'Something went wrong. Please try again.';
  static const networkMessage =
      'Network error. Check your connection and try again.';
  static const serviceUnavailable =
      'Service is temporarily unavailable. Please try again later.';
  static const sessionExpired = 'Your session expired. Please sign in again.';
  static const notFoundMessage = 'We could not find what you were looking for.';
  static const tooManyRequests =
      'Too many attempts. Please wait a moment and try again.';

  static String from(
    Object error, {
    String? fallback,
    String? feature,
  }) {
    final genericFallback = fallback ?? _featureFallback(feature);
    if (error is DioException) {
      return _fromDio(error, fallback: genericFallback, feature: feature);
    }
    return _fromGeneric(error, fallback: genericFallback);
  }

  static String _featureFallback(String? feature) {
    if (feature == null || feature.trim().isEmpty) return defaultMessage;
    return 'Could not complete your $feature request. Please try again.';
  }

  static String _fromDio(
    DioException error, {
    required String fallback,
    String? feature,
  }) {
    final code = error.response?.statusCode;
    final server = _userFriendlyServerMessage(extractServerMessage(error.response?.data));

    if (code == 401 || code == 403) {
      return server ?? sessionExpired;
    }
    if (code == 404) {
      return server ?? notFoundMessage;
    }
    if (code == 409) {
      return server ?? fallback;
    }
    if (code == 429) {
      return server ?? tooManyRequests;
    }
    if (code != null && code >= 500) {
      return server ?? serviceUnavailable;
    }

    if (_isNetworkIssue(error)) {
      return networkMessage;
    }

    if (server != null) return server;

    if (code != null && code >= 400) {
      return fallback;
    }

    return fallback;
  }

  static String _fromGeneric(Object error, {required String fallback}) {
    if (_looksLikeNetworkError(error.toString())) {
      return networkMessage;
    }
    final fromException = error is Exception ? error.toString() : null;
    if (fromException != null) {
      final cleaned = fromException.replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
      final friendly = _userFriendlyServerMessage(cleaned);
      if (friendly != null) return friendly;
    }
    return fallback;
  }

  static String? extractServerMessage(dynamic data) {
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty) return data.trim();
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      for (final key in ['message', 'error', 'detail']) {
        final value = map[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
      final errors = map['errors'];
      if (errors is List && errors.isNotEmpty) {
        final parts = <String>[];
        for (final item in errors) {
          if (item is String && item.trim().isNotEmpty) {
            parts.add(item.trim());
          } else if (item is Map) {
            final msg = item['message'] ?? item['msg'];
            if (msg is String && msg.trim().isNotEmpty) parts.add(msg.trim());
          }
        }
        if (parts.isNotEmpty) return parts.join(' ');
      }
    }
    return null;
  }

  static String? _userFriendlyServerMessage(String? raw) {
    if (raw == null) return null;
    final text = raw.trim();
    if (text.isEmpty) return null;
    if (_looksTechnical(text)) return null;
    if (text.length > 180) return null;
    return text;
  }

  static bool _isNetworkIssue(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }
    return _looksLikeNetworkError(error.message ?? error.toString());
  }

  static bool _looksLikeNetworkError(String value) {
    final lower = value.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused') ||
        lower.contains('connection reset') ||
        lower.contains('connection closed') ||
        lower.contains('connection timed out') ||
        lower.contains('network error');
  }

  static bool _looksTechnical(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('<!doctype html') || lower.contains('<html')) {
      return true;
    }
    const technicalFragments = [
      'exception',
      'stacktrace',
      'stack trace',
      'dioexception',
      'socketexception',
      'type \'',
      'is not a subtype',
      'internal server error',
      'route not found',
      'failed to parse private key',
      'invalid pem',
      'prisma',
      'sql',
      'undefined',
      'null pointer',
      'traceback',
      'json decode',
      'unexpected token',
      'syntaxerror',
      'assertion failed',
      'http ',
      '(http ',
      'statuscode',
      'status code',
      'request failed (',
      'request failed(',
      'backend may use',
      'api not found',
      'ai_auth_bearer_token',
      'missing ai_api_base_url',
      'stateerror',
    ];
    for (final fragment in technicalFragments) {
      if (lower.contains(fragment)) return true;
    }
    if (RegExp(r'\b5\d{2}\b').hasMatch(lower) && lower.contains('failed')) {
      return true;
    }
    if (RegExp(r'\b4\d{2}\b').hasMatch(lower) && lower.contains('http')) {
      return true;
    }
    return false;
  }
}
