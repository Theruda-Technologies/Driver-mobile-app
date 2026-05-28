/// Helpers for authenticated E2E tests with a mocked backend.
library;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:driver/main.dart' as app;
import 'package:driver/core/navigation/app_navigator.dart';
import 'package:driver/core/network/api_client.dart';
import 'package:driver/injection/service_locator.dart';
import 'package:driver/features/auth/presentation/pages/login_page.dart';
import 'package:driver/features/dashboard/presentation/pages/driver_dashboard_page.dart';

import 'e2e_helpers.dart';

Future<void> markOnboardingCompletedForAuth() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_v2_completed', true);
}

Future<void> seedAuth() async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'auth_token', value: testJwt());
  await storage.write(
    key: 'auth_user',
    value: jsonEncode(<String, Object>{
      'id': 'test-user-id',
      'firstName': 'Test',
      'lastName': 'Driver',
      'email': 'test@example.com',
      'phone': '+251911223344',
    }),
  );
}

Future<void> clearAuth() async {
  const storage = FlutterSecureStorage();
  await storage.deleteAll();
}

/// Boots the app as an authenticated user with a mocked dio backend.
Future<void> bootAuthenticated(WidgetTester tester) async {
  await clearAuth();
  await markOnboardingCompletedForAuth();
  await seedAuth();

  app.main();

  var installed = false;
  for (var i = 0; i < 80; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (!installed && getIt.isRegistered<ApiClient>()) {
      getIt<ApiClient>().dio.interceptors.insert(0, MockBackend());
      installed = true;
      break;
    }
  }
  expect(
    installed,
    isTrue,
    reason: 'ApiClient was never registered with the service locator',
  );

  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> pushRouteFromDashboard(WidgetTester tester, String route) async {
  appNavigatorKey.currentState!.pushNamed(route);
  await settleRoute(tester);
}

Future<void> popToDashboard(WidgetTester tester) async {
  final nav = appNavigatorKey.currentState!;
  while (nav.canPop()) {
    nav.pop();
    await settleRoute(tester, cycles: 4);
  }
  expect(find.byType(DriverDashboardPage), findsOneWidget);
}

/// JWT-shaped token with a far-future `exp` claim.
String testJwt() {
  String b64u(String json) =>
      base64Url.encode(utf8.encode(json)).replaceAll('=', '');
  final header = b64u('{"alg":"none","typ":"JWT"}');
  final payload = b64u(
    '{"exp":9999999999,"iat":1700000000,"sub":"test-user-id"}',
  );
  return '$header.$payload.signature';
}

/// Dio interceptor that resolves every request with canned JSON.
class MockBackend extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final path = _normalize(options.path);
    final method = options.method.toUpperCase();

    Response<dynamic> ok(Object? body) => Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
          data: body,
        );

    if (method == 'GET' && path == '/driver/vehicles') {
      return handler.resolve(ok(<Map<String, Object?>>[_mockVehicle()]));
    }
    if (method == 'GET' && path.startsWith('/driver/vehicles/')) {
      return handler.resolve(ok(_mockVehicle()));
    }
    if (method == 'GET' && path == '/driver/maintenance/upcoming') {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' && path == '/driver/maintenance/history') {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' && path == '/driver/maintenance/catalog') {
      return handler.resolve(ok(<String, dynamic>{'items': <dynamic>[]}));
    }
    if (method == 'GET' && path.startsWith('/driver/maintenance/health/')) {
      return handler.resolve(
        ok(<String, Object?>{'score': 100, 'issues': <dynamic>[]}),
      );
    }
    if (method == 'GET' && path == '/driver/maintenance/notifications') {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' && path == '/driver/notifications') {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' && path.startsWith('/driver/community/posts')) {
      return handler.resolve(
        ok(<String, dynamic>{
          'posts': <dynamic>[],
          'total': 0,
          'page': 1,
          'pageSize': 20,
        }),
      );
    }
    if (method == 'GET' &&
        RegExp(r'^/driver/education/[^/]+/image$').hasMatch(path)) {
      return handler.resolve(
        Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 404,
          data: <String, dynamic>{'message': 'Image not found'},
        ),
      );
    }
    if (method == 'GET' && path == '/driver/education') {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' && path.startsWith('/driver/education/search')) {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' &&
        RegExp(r'^/driver/education/[^/]+$').hasMatch(path)) {
      return handler.resolve(
        Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 404,
          data: <String, dynamic>{'message': 'Not found'},
        ),
      );
    }
    if (method == 'GET' && path.startsWith('/education/content')) {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' && path.startsWith('/drivers/appointments')) {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' &&
        (path == '/services/nearby' || path.endsWith('/services/nearby'))) {
      return handler.resolve(ok(<Map<String, Object?>>[_mockGarage()]));
    }
    if (method == 'GET' &&
        path.contains('/garages/ratings/') &&
        path.endsWith('/summary')) {
      return handler.resolve(
        ok(<String, Object?>{'averageRating': 4.5, 'totalRatings': 12}),
      );
    }
    if (method == 'GET' &&
        path.contains('/garages/availability/') &&
        path.endsWith('/slots')) {
      return handler.resolve(ok(_mockAvailabilitySlots()));
    }
    if (method == 'GET' &&
        RegExp(r'^/garages/[^/]+/profile$').hasMatch(path)) {
      return handler.resolve(ok(_mockGarageProfile()));
    }
    if (method == 'GET' &&
        RegExp(r'^/garages/[^/]+/services$').hasMatch(path)) {
      return handler.resolve(ok(_mockGarageServices()));
    }
    if (method == 'GET' && path.startsWith('/garages/')) {
      return handler.resolve(ok(<dynamic>[]));
    }
    if (method == 'GET' && path == '/driver/profile') {
      return handler.resolve(
        ok(<String, Object?>{
          'id': 'test-user-id',
          'firstName': 'Test',
          'lastName': 'Driver',
          'email': 'test@example.com',
          'phone': '+251911223344',
        }),
      );
    }
    if (method == 'POST' && path.endsWith('/drivers/auth/login')) {
      return handler.resolve(
        ok(<String, Object?>{
          'token': testJwt(),
          'driver': <String, Object?>{
            'id': 'test-user-id',
            'firstName': 'Test',
            'lastName': 'Driver',
            'email': 'test@example.com',
            'phone': '+251911223344',
          },
        }),
      );
    }
    if (method == 'GET') {
      return handler.resolve(ok(<dynamic>[]));
    }
    handler.resolve(ok(<String, dynamic>{}));
  }

  static String _normalize(String pathOrUrl) {
    var path = pathOrUrl;
    if (path.startsWith('http')) {
      final uri = Uri.tryParse(path);
      path = uri?.path ?? pathOrUrl;
    }
    final queryIndex = path.indexOf('?');
    if (queryIndex >= 0) {
      path = path.substring(0, queryIndex);
    }
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    return path;
  }

  Map<String, Object?> _mockGarage() => <String, Object?>{
        'id': 'g1',
        'name': 'Test Garage',
        'address': 'Addis Ababa',
        'subtitle': 'Addis Ababa',
        'phone': '+251911000000',
        'latitude': 9.03,
        'longitude': 38.74,
        'rating': 4.5,
        'reviewsCount': 12,
        'distanceKm': 1.2,
        'isOpen': true,
        'isRegistered': true,
        'onsiteServiceEnabled': true,
        'availabilitySlots': _mockAvailabilitySlots(),
        'services': <Map<String, String>>[
          <String, String>{'id': 'svc1', 'name': 'Oil Change'},
        ],
      };

  Map<String, Object?> _mockGarageProfile() => <String, Object?>{
        'id': 'g1',
        'name': 'Test Garage',
        'services': _mockGarageServices(),
        'availabilitySlots': _mockAvailabilitySlots(),
        'setting': <String, Object?>{
          'data': <String, Object?>{'onsiteServiceEnabled': true},
        },
        'rating': <String, Object?>{'averageRating': 4.5, 'totalRatings': 12},
      };

  List<Map<String, String>> _mockGarageServices() => <Map<String, String>>[
        <String, String>{'id': 'svc1', 'name': 'Oil Change'},
      ];

  List<Map<String, Object>> _mockAvailabilitySlots() => <Map<String, Object>>[
        <String, Object>{
          'dayOfWeek': 'MONDAY',
          'startMinute': 540,
          'endMinute': 1020,
        },
        <String, Object>{
          'dayOfWeek': 'TUESDAY',
          'startMinute': 540,
          'endMinute': 1020,
        },
        <String, Object>{
          'dayOfWeek': 'WEDNESDAY',
          'startMinute': 540,
          'endMinute': 1020,
        },
        <String, Object>{
          'dayOfWeek': 'THURSDAY',
          'startMinute': 540,
          'endMinute': 1020,
        },
        <String, Object>{
          'dayOfWeek': 'FRIDAY',
          'startMinute': 540,
          'endMinute': 1020,
        },
      ];

  Map<String, Object?> _mockVehicle() => <String, Object?>{
        'id': 'v1',
        '_id': 'v1',
        'driverId': 'test-user-id',
        'plateNumber': 'AA-12345',
        'make': 'Toyota',
        'model': 'Corolla',
        'year': 2020,
        'color': 'White',
        'fuelType': 'Petrol',
        'mileage': 50000,
      };
}

/// Asserts the app booted to dashboard, not login.
void expectAuthenticatedDashboard() {
  expect(find.byType(DriverDashboardPage), findsOneWidget);
  expect(find.byType(LoginPage), findsNothing);
  expect(find.text('CarCare'), findsWidgets);
}
