/// Authenticated E2E — Vehicles module (mocked backend)
///
/// Run: flutter test integration_test/vehicles_authenticated_test.dart -d emulator-5554
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/vehicles/presentation/pages/vehicles_list_page.dart';
import 'helpers/auth_mock_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Vehicles module (authenticated)', () {
    testWidgets('/vehicles renders with mocked Toyota Corolla', (
      tester,
    ) async {
      await bootAuthenticated(tester);
      await pushRouteFromDashboard(tester, '/vehicles');

      expect(find.byType(VehiclesListPage), findsOneWidget);
      expect(find.textContaining('Toyota'), findsWidgets);
      expect(find.textContaining('AA-12345'), findsWidgets);
    });
  });
}
