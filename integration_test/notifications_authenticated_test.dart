/// Authenticated E2E — Notifications module (mocked backend)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/notifications/presentation/pages/notifications_page.dart';
import 'helpers/auth_mock_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notifications module (authenticated)', () {
    testWidgets('/notifications renders page with mock data', (
      tester,
    ) async {
      await bootAuthenticated(tester);
      await pushRouteFromDashboard(tester, '/notifications');

      expect(find.byType(NotificationsPage), findsOneWidget);
      expect(find.text('Notifications'), findsWidgets);
    });
  });
}
