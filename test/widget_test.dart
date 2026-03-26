import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnova/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  testWidgets('Learnova login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LearnovaApp());
    await tester.pump(const Duration(milliseconds: 3200));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Demo Credentials'), findsNothing);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('Kid management screen renders content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: KidManagementScreen(
          parentEmail: 'parent@learnova.com',
          initialChildren: const <ChildAccount>[
            ChildAccount(
              id: 'seed-child-1',
              nickname: 'Spark',
              username: 'sparkkid',
              password: 'Learnova@123',
              level: 'Level 1 - Starter',
            ),
            ChildAccount(
              id: 'seed-child-2',
              nickname: 'Nova',
              username: 'novakid',
              password: 'Learnova@123',
              level: 'Level 2 - Explorer',
            ),
          ],
          onChildAdded: _noopChild,
          onChildUpdated: _noopChild,
          onChildDeleted: _noopDelete,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Kid Management'), findsOneWidget);
    expect(find.text('Total Kids'), findsOneWidget);
    expect(find.text('Kid Names'), findsOneWidget);
    expect(find.text('Add New Kid'), findsOneWidget);
  });
}

void _noopChild(ChildAccount child) {}

void _noopDelete(String id) {}
