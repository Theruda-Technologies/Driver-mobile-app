/// Authenticated E2E — Maintenance module (mocked backend)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/maintenance/presentation/pages/maintenance_upcoming_page.dart';
import 'package:driver/features/maintenance/presentation/pages/maintenance_history_page.dart';
import 'helpers/auth_mock_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Maintenance module (authenticated)', () {
    testWidgets('/maintenance/upcoming renders with mock data', (
      tester,
    ) async {
      await bootAuthenticated(tester);
      await pushRouteFromDashboard(tester, '/maintenance/upcoming');

      expect(find.byType(MaintenanceUpcomingPage), findsOneWidget);
      expect(find.text('Upcoming Maintenance'), findsWidgets);
    });

    testWidgets('/maintenance/history renders with mock data', (
      tester,
    ) async {
      await bootAuthenticated(tester);
      await pushRouteFromDashboard(tester, '/maintenance/history');

      expect(find.byType(MaintenanceHistoryPage), findsOneWidget);
      expect(find.text('Maintenance History'), findsWidgets);
    });
  });
}
