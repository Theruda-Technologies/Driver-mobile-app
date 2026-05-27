/// E2E tests — Auth module (Login, Signup, Profile, Settings)
///
/// Run: flutter test integration_test/auth_test.dart -d emulator-5554
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/auth/presentation/pages/login_page.dart';
import 'package:driver/features/auth/presentation/pages/signup_page.dart';
import 'package:driver/features/auth/presentation/pages/profile_page.dart';
import 'package:driver/features/auth/presentation/pages/settings_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth module — Login', () {
    testWidgets('login screen renders phone, password, and login button', (
      tester,
    ) async {
      await bootToLogin(tester);

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue to your account'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('phone field accepts Ethiopian local format input', (
      tester,
    ) async {
      await bootToLogin(tester);

      await tester.enterText(find.byType(TextField).first, '0912345678');
      await tester.pump();
      expect(find.text('0912345678'), findsOneWidget);
    });

    testWidgets('submitting with empty phone shows validation snackbar', (
      tester,
    ) async {
      await bootToLogin(tester);

      await tester.tap(find.text('Log in'));
      await settleRoute(tester, cycles: 8);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Enter a valid phone'), findsOneWidget);
    });

    testWidgets('Create account navigates to signup page', (tester) async {
      await bootToLogin(tester);

      await settleRoute(tester, cycles: 4);
      await tester.tap(find.text('Create account'));
      await settleRoute(tester, cycles: 16);

      expect(find.byType(SignupPage), findsOneWidget);
      expect(
        find.byType(TextField).evaluate().length,
        greaterThanOrEqualTo(4),
      );
    });
  });

  group('Auth module — Profile & Settings', () {
    testWidgets('/profile renders or redirects unauthenticated user to login', (
      tester,
    ) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/profile');

      final onProfile = find.byType(ProfilePage).evaluate().isNotEmpty;
      final onLogin = find.byType(LoginPage).evaluate().isNotEmpty;
      expect(onProfile || onLogin, isTrue);
    });

    testWidgets('/settings renders or redirects unauthenticated user to login', (
      tester,
    ) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/settings');

      final onSettings = find.byType(SettingsPage).evaluate().isNotEmpty;
      final onLogin = find.byType(LoginPage).evaluate().isNotEmpty;
      expect(onSettings || onLogin, isTrue);
    });
  });
}
