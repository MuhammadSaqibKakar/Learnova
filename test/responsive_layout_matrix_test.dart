import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnova/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Desktop register screen renders safely', (
    WidgetTester tester,
  ) async {
    _setDesktopSize(tester, const Size(1600, 1000));
    addTearDown(() => _resetSize(tester));

    await tester.pumpWidget(
      MaterialApp(
        home: RegisterScreen(
          random: Random(1),
          onRegisterParent: _noopRegisterParent,
          onOpenThemePicker: _noopOpenTheme,
          onGoToLogin: _noopExit,
        ),
      ),
    );

    await _pumpForDesktop(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Parent Registration'), findsOneWidget);
    expect(find.text('Register Parent Account'), findsOneWidget);
  });

  testWidgets('Desktop forgot password screen renders safely', (
    WidgetTester tester,
  ) async {
    _setDesktopSize(tester, const Size(1600, 1000));
    addTearDown(() => _resetSize(tester));

    await tester.pumpWidget(
      MaterialApp(
        home: ForgotPasswordScreen(
          random: Random(2),
          onResetPassword: _noopResetPassword,
          onOpenThemePicker: _noopOpenTheme,
          onGoToLogin: _noopExit,
        ),
      ),
    );

    await _pumpForDesktop(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Forgot Password'), findsOneWidget);
    expect(find.text('Set New Password'), findsOneWidget);
  });

  testWidgets('Desktop parent dashboard renders safely', (
    WidgetTester tester,
  ) async {
    _setDesktopSize(tester, const Size(1720, 1000));
    addTearDown(() => _resetSize(tester));

    await tester.pumpWidget(
      MaterialApp(
        home: ParentDashboardScreen(
          parentEmail: 'parent@learnova.com',
          initialChildren: const <ChildAccount>[
            ChildAccount(
              id: 'seed-child-1',
              nickname: 'Spark',
              username: 'sparkkid',
              password: 'Learnova@123',
              level: 'Level 1 - Starter',
              createdAtEpoch: 1735689600000,
            ),
            ChildAccount(
              id: 'seed-child-2',
              nickname: 'Nova',
              username: 'novakid',
              password: 'Learnova@123',
              level: 'Level 2 - Explorer',
              createdAtEpoch: 1735776000000,
            ),
          ],
          onChildAdded: _noopChild,
          onChildUpdated: _noopChild,
          onChildDeleted: _noopChildDelete,
          onOpenThemePicker: _noopOpenTheme,
          onExit: _noopExit,
        ),
      ),
    );

    await _pumpForDesktop(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Parent Dashboard'), findsWidgets);
    expect(find.textContaining('Kid Reports'), findsWidgets);
  });

  testWidgets('Desktop kid dashboard renders safely', (
    WidgetTester tester,
  ) async {
    _setDesktopSize(tester, const Size(1680, 1000));
    addTearDown(() => _resetSize(tester));

    await tester.pumpWidget(
      MaterialApp(
        home: KidDashboardScreen(
          childId: 'seed-child-1',
          childName: 'Spark',
          level: 'Level 1 - Starter',
          onExit: _noopExit,
        ),
      ),
    );

    await _pumpForDesktop(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Spark'), findsWidgets);
    expect(find.text('Subjects'), findsOneWidget);
    expect(find.text('Leaderboard'), findsWidgets);
  });

  testWidgets('Mobile lecture flow renders without overflow', (
    WidgetTester tester,
  ) async {
    _setDesktopSize(tester, const Size(360, 760));
    addTearDown(() => _resetSize(tester));

    await tester.pumpWidget(
      MaterialApp(
        home: KidDashboardScreen(
          childId: 'seed-child-1',
          childName: 'Spark',
          level: 'Level 1 - Starter',
          onExit: _noopExit,
        ),
      ),
    );

    await _pumpForDesktop(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('English').first);
    await _pumpForDesktop(tester);
    expect(find.text('Play Path 1 to 10'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('1').first);
    await _pumpForDesktop(tester);

    expect(find.textContaining('Letters and Sounds'), findsWidgets);
  });

  testWidgets('Compact mobile level path renders without overflow', (
    WidgetTester tester,
  ) async {
    _setDesktopSize(tester, const Size(320, 640));
    addTearDown(() => _resetSize(tester));

    await tester.pumpWidget(
      MaterialApp(
        home: KidDashboardScreen(
          childId: 'seed-child-1',
          childName: 'Spark',
          level: 'Level 1 - Starter',
          onExit: _noopExit,
        ),
      ),
    );

    await _pumpForDesktop(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('English').first);
    await _pumpForDesktop(tester);

    expect(find.text('Play Path 1 to 10'), findsOneWidget);
    expect(find.text('Tap the open stage to play'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Compact mobile lecture flow renders without overflow', (
    WidgetTester tester,
  ) async {
    _setDesktopSize(tester, const Size(320, 640));
    addTearDown(() => _resetSize(tester));

    await tester.pumpWidget(
      MaterialApp(
        home: KidDashboardScreen(
          childId: 'seed-child-1',
          childName: 'Spark',
          level: 'Level 1 - Starter',
          onExit: _noopExit,
        ),
      ),
    );

    await _pumpForDesktop(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('English').first);
    await _pumpForDesktop(tester);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('1').first);
    await _pumpForDesktop(tester);

    expect(find.textContaining('Letters and Sounds'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

void _setDesktopSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
}

Future<void> _pumpForDesktop(WidgetTester tester) async {
  await tester.pump();
  for (int i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

void _resetSize(WidgetTester tester) {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
}

void _noopRegisterParent(String email, String password) {}

String? _noopResetPassword(String email, String newPassword) => null;

void _noopOpenTheme(BuildContext context) {}

void _noopExit(BuildContext context) {}

void _noopChild(ChildAccount child) {}

void _noopChildDelete(String childId) {}
