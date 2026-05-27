/// Authenticated E2E — Education module (mocked backend)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/education/presentation/pages/education_center_page.dart';
import 'helpers/auth_mock_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Education module (authenticated)', () {
    testWidgets('/education renders center with mock data', (tester) async {
      await bootAuthenticated(tester);
      await pushRouteFromDashboard(tester, '/education');

      expect(find.byType(EducationCenterPage), findsOneWidget);
      expect(find.text('CarCare'), findsWidgets);
    });
  });
}
