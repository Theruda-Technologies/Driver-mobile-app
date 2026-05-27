library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../auth/data/datasources/auth_local_datasource.dart';

class AiApiClient {
  AiApiClient({
    required AuthLocalDataSource authLocal,
    Dio? dio,
  })  : _authLocal = authLocal,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _resolveBaseUrl(),
                // RAG / LLM backends often cold-start on free hosts; answers can exceed 30s.
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 120),
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Local RAG without JWT_SECRET: set AI_DEV_USER_ID=<driver-uuid> in .env
          // (RAG accepts X-User-Id only when JWT_SECRET is unset on the Python server).
          final devUserId = (dotenv.env['AI_DEV_USER_ID'] ?? '').trim();
          if (kDebugMode && devUserId.isNotEmpty) {
            options.headers['X-User-Id'] = devUserId;
            options.headers.remove('Authorization');
            return handler.next(options);
          }

          // Optional override (e.g. Supabase access token for hosted RAG).
          final envToken = (dotenv.env['AI_AUTH_BEARER_TOKEN'] ?? '').trim();
          if (_looksLikeJwt(envToken)) {
            options.headers['Authorization'] = 'Bearer $envToken';
            return handler.next(options);
          }
          if (kDebugMode && envToken.isNotEmpty) {
            debugPrint(
              'AI_AUTH_BEARER_TOKEN is set but not a JWT; falling back to stored login token.',
            );
          }

          // Default: same JWT as driver-garage-backend login (required when RAG has JWT_SECRET).
          final token = await _authLocal.getToken();
          final trimmed = token?.trim() ?? '';
          if (trimmed.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $trimmed';
          }
          return handler.next(options);
        },
      ),
    );
  }

  final AuthLocalDataSource _authLocal;
  final Dio _dio;

  static String _resolveBaseUrl() {
    final env = dotenv.env['AI_API_BASE_URL']?.trim() ?? '';
    if (env.isEmpty) {
      throw StateError(
        'Missing AI_API_BASE_URL in .env. Example: AI_API_BASE_URL=https://rag-system-iig7.onrender.com',
      );
    }
    return env.endsWith('/') ? env.substring(0, env.length - 1) : env;
  }

  Future<Map<String, dynamic>> createSession({
    String? vehicleId,
    String? title,
    Map<String, dynamic>? vehicleContext,
  }) async {
    final payload = <String, dynamic>{};
    if (vehicleId != null && vehicleId.trim().isNotEmpty) {
      payload['vehicle_id'] = vehicleId.trim();
    }
    if (title != null && title.trim().isNotEmpty) {
      payload['title'] = title.trim();
    }
    if (vehicleContext != null && vehicleContext.isNotEmpty) {
      payload['vehicle_context'] = vehicleContext;
    }
    final res = await _dio.post<dynamic>('/sessions', data: payload);
    return _asJsonMap(res.data);
  }

  Future<List<Map<String, dynamic>>> listSessions() async {
    final res = await _dio.get<dynamic>('/sessions');
    final data = res.data;
    if (data is List) {
      return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (data is Map && data['items'] is List) {
      final items = data['items'] as List<dynamic>;
      return items.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return const [];
  }

  Future<Map<String, dynamic>> getMessages(
    String sessionId, {
    String? before,
  }) async {
    final res = await _dio.get<dynamic>(
      '/sessions/$sessionId/messages',
      queryParameters: {
        if (before != null && before.trim().isNotEmpty) 'before': before.trim(),
      },
    );
    final data = res.data;
    // Many RAG backends return a bare JSON array of messages; Dio must not cast it to Map.
    if (data is List) {
      return <String, dynamic>{'items': data};
    }
    return _asJsonMap(data);
  }

  Future<Map<String, dynamic>> sendMessage(
    String sessionId, {
    required String message,
    String? vehicleId,
    Map<String, dynamic>? vehicleContext,
  }) async {
    final payload = <String, dynamic>{'message': message};
    final v = vehicleId?.trim();
    if (v != null && v.isNotEmpty) {
      payload['vehicle_id'] = v;
    }
    if (vehicleContext != null && vehicleContext.isNotEmpty) {
      payload['vehicle_context'] = vehicleContext;
    }
    final res = await _dio.post<dynamic>(
      '/sessions/$sessionId/messages',
      data: payload,
    );
    return _asJsonMap(res.data);
  }

  Future<void> deleteSession(String sessionId) async {
    await _dio.delete('/sessions/$sessionId');
  }

  static Map<String, dynamic> _asJsonMap(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }

  bool _looksLikeJwt(String token) {
    if (token.isEmpty) return false;
    final parts = token.split('.');
    return parts.length == 3 &&
        parts[0].isNotEmpty &&
        parts[1].isNotEmpty &&
        parts[2].isNotEmpty;
  }
}
