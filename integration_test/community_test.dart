/// E2E tests — Community module
///
/// Run: flutter test integration_test/community_test.dart -d emulator-5554
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/community/presentation/pages/community_feed_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Community module', () {
    testWidgets('/community renders the community feed', (tester) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/community');

      expect(find.byType(CommunityFeedPage), findsOneWidget);
      expect(find.text('CarCare'), findsWidgets);
      expect(find.text('Community'), findsWidgets);
    });
  });
}
