/// Authenticated E2E — AI Chat module (mocked backend)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/ai/presentation/pages/ai_chat_page.dart';
import 'helpers/auth_mock_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AI module (authenticated)', () {
    testWidgets('/ai-chat shows welcome bubble with mock session', (
      tester,
    ) async {
      await bootAuthenticated(tester);
      await pushRouteFromDashboard(tester, '/ai-chat');

      expect(find.byType(AiChatPage), findsOneWidget);
      expect(
        find.textContaining('CarCare AI assistant'),
        findsOneWidget,
      );
    });
  });
}
