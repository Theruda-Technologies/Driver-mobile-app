/// Authenticated E2E — Dashboard module (mocked backend)
///
/// Run: flutter test integration_test/dashboard_authenticated_test.dart -d emulator-5554
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/auth_mock_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard module (authenticated)', () {
    testWidgets('cached JWT boots straight into dashboard', (tester) async {
      await bootAuthenticated(tester);
      expectAuthenticatedDashboard();
    });
  });
}
