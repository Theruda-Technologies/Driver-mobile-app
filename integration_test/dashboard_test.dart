/// E2E tests — Dashboard module
///
/// Run: flutter test integration_test/dashboard_test.dart -d emulator-5554
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/dashboard/presentation/pages/driver_dashboard_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard module', () {
    testWidgets('/driver-dashboard renders main shell', (tester) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/driver-dashboard');

      expect(find.byType(DriverDashboardPage), findsOneWidget);
      expect(find.text('CarCare'), findsWidgets);
    });
  });
}
