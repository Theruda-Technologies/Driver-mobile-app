/// E2E tests — Education module
///
/// Run: flutter test integration_test/education_test.dart -d emulator-5554
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/education/presentation/pages/education_center_page.dart';
import 'package:driver/features/education/presentation/pages/education_articles_list_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Education module', () {
    testWidgets('/education renders the education center shell', (
      tester,
    ) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/education');

      expect(find.byType(EducationCenterPage), findsOneWidget);
      expect(find.text('CarCare'), findsWidgets);
    });

    testWidgets('/education/all renders the articles list shell', (
      tester,
    ) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/education/all');

      expect(find.byType(EducationArticlesListPage), findsOneWidget);
      expect(find.byType(AppBar), findsWidgets);
    });
  });
}
