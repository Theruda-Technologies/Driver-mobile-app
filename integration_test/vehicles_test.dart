/// E2E tests — Vehicles module
///
/// Run: flutter test integration_test/vehicles_test.dart -d emulator-5554
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:driver/features/vehicles/presentation/pages/vehicles_list_page.dart';
import 'package:driver/features/vehicles/presentation/pages/add_vehicle_page.dart';
import 'package:driver/features/vehicles/presentation/pages/vehicle_detail_page.dart';
import 'helpers/e2e_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Vehicles module', () {
    testWidgets('/vehicles renders the vehicles list', (tester) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/vehicles');

      expect(find.byType(VehiclesListPage), findsOneWidget);
      expect(find.text('CarCare'), findsWidgets);
      expect(find.text('My Vehicles'), findsWidgets);
    });

    testWidgets('/vehicles/add renders the add-vehicle wizard', (tester) async {
      await bootToLogin(tester);
      await pushRoute(tester, '/vehicles/add');

      expect(find.byType(AddVehiclePage), findsOneWidget);
      expect(find.text('Add Vehicle'), findsWidgets);
    });

    testWidgets('/vehicles/detail renders detail shell for unknown id', (
      tester,
    ) async {
      await bootToLogin(tester);
      await pushRoute(
        tester,
        '/vehicles/detail',
        arguments: 'test-id-does-not-exist',
      );

      expect(find.byType(VehicleDetailPage), findsOneWidget);
      final hasTitle =
          find.text('Vehicle Details').evaluate().isNotEmpty ||
          find.byType(AppBar).evaluate().isNotEmpty;
      expect(hasTitle, isTrue);
    });
  });
}
