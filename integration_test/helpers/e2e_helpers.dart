/// Shared helpers for CarCare Driver end-to-end integration tests.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:driver/main.dart' as app;
import 'package:driver/core/navigation/app_navigator.dart';
import 'package:driver/features/auth/presentation/pages/login_page.dart';

/// Boots the app and pumps until the initial UI has settled.
Future<void> bootApp(WidgetTester tester, {int pumpCycles = 40}) async {
  app.main();
  for (var i = 0; i < pumpCycles; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
}

/// Pumps long enough for a route push + page initState + first async work.
Future<void> settleRoute(WidgetTester tester, {int cycles = 16}) async {
  for (var i = 0; i < cycles; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> markOnboardingCompleted({required bool completed}) async {
  final prefs = await SharedPreferences.getInstance();
  if (completed) {
    await prefs.setBool('onboarding_v2_completed', true);
  } else {
    await prefs.remove('onboarding_v2_completed');
  }
}

/// Boots straight to the Login page (onboarding skipped, no auth token).
Future<void> bootToLogin(WidgetTester tester) async {
  await markOnboardingCompleted(completed: true);
  await bootApp(tester);
  expect(
    find.byType(LoginPage),
    findsOneWidget,
    reason: 'expected to land on LoginPage after onboarding/auth-check',
  );
}

Future<void> pushRoute(
  WidgetTester tester,
  String route, {
  Object? arguments,
}) async {
  appNavigatorKey.currentState!.pushNamed(route, arguments: arguments);
  await settleRoute(tester);
}

Future<void> popToLogin(WidgetTester tester) async {
  final nav = appNavigatorKey.currentState!;
  while (nav.canPop()) {
    nav.pop();
    await settleRoute(tester, cycles: 4);
  }
  expect(find.byType(LoginPage), findsOneWidget);
}
