/// E2E tests — Maintenance module
///
/// Run: flutter test integration_test/maintenance_test.dart -d emulator-5554
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/maintenance/presentation/pages/maintenance_upcoming_page.dart';
import 'package:driver/features/maintenance/presentation/pages/maintenance_history_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Maintenance module', () {
    testWidgets('/maintenance/upcoming renders upcoming page', (tester) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/maintenance/upcoming');

      expect(find.byType(MaintenanceUpcomingPage), findsOneWidget);
      expect(find.text('CarCare'), findsWidgets);
      expect(find.text('Upcoming Maintenance'), findsWidgets);
    });

    testWidgets('/maintenance/history renders history page', (tester) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/maintenance/history');

      expect(find.byType(MaintenanceHistoryPage), findsOneWidget);
      expect(find.text('CarCare'), findsWidgets);
      expect(find.text('Maintenance History'), findsWidgets);
    });
  });
}
