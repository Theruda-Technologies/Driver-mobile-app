/// Authenticated E2E — Community module (mocked backend)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/community/presentation/pages/community_feed_page.dart';
import 'helpers/auth_mock_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Community module (authenticated)', () {
    testWidgets('/community renders feed with mock data', (tester) async {
      await bootAuthenticated(tester);
      await pushRouteFromDashboard(tester, '/community');

      expect(find.byType(CommunityFeedPage), findsOneWidget);
      expect(find.text('Community'), findsWidgets);
    });
  });
}
