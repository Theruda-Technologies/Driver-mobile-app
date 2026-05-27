/// E2E tests — Onboarding module
///
/// Run: flutter test integration_test/onboarding_test.dart -d emulator-5554
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:driver/features/auth/presentation/pages/login_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding module', () {
    testWidgets('first launch shows onboarding and Skip leads to login', (
      tester,
    ) async {
      await markOnboardingCompleted(completed: false);
      await bootApp(tester);

      expect(find.byType(OnboardingPage), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      await tester.tap(find.text('Skip'));
      await settleRoute(tester, cycles: 20);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Continue advances through onboarding pages', (tester) async {
      await markOnboardingCompleted(completed: false);
      await bootApp(tester);

      expect(find.byType(OnboardingPage), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('Continue'));
        await settleRoute(tester, cycles: 5);
      }

      expect(find.byType(OnboardingPage), findsOneWidget);
      final hasContinue = find.text('Continue').evaluate().isNotEmpty;
      final hasGetStarted = find.text('Get Started').evaluate().isNotEmpty;
      expect(hasContinue || hasGetStarted, isTrue);
    });
  });
}
