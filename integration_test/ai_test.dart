/// E2E tests — AI Chat module
///
/// Run: flutter test integration_test/ai_test.dart -d emulator-5554
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/ai/presentation/pages/ai_chat_page.dart';
import 'package:driver/features/ai/presentation/pages/ai_chat_history_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AI module', () {
    testWidgets('/ai-chat renders chat page with welcome bubble', (
      tester,
    ) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/ai-chat');

      expect(find.byType(AiChatPage), findsOneWidget);
      expect(
        find.textContaining('CarCare AI assistant'),
        findsOneWidget,
      );
    });

    testWidgets('/ai-chat/history renders chat history shell', (
      tester,
    ) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/ai-chat/history');

      expect(find.byType(AiChatHistoryPage), findsOneWidget);
      expect(find.text('Chat History'), findsOneWidget);
    });
  });
}
