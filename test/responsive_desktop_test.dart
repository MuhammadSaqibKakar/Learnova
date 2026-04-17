import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnova/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Desktop login layout renders without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const LearnovaApp());
    await tester.pump(const Duration(milliseconds: 3800));

    expect(tester.takeException(), isNull);
    expect(find.text('Welcome Back'), findsOneWidget);
  });

  testWidgets('Desktop admin dashboard renders key sections', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: AdminDashboardScreen(
          adminEmail: 'admin@learnova.com',
          adminPassword: 'Learnova@123',
          parentAccounts: const <ParentAccount>[
            ParentAccount(
              id: 'p-1',
              email: 'parent@learnova.com',
              password: 'Learnova@123',
              createdAtEpoch: 1735689600000,
            ),
          ],
          initialChildren: const <ChildAccount>[
            ChildAccount(
              id: 'c-1',
              nickname: 'Spark',
              username: 'sparkkid',
              password: 'Learnova@123',
              level: 'Level 1 - Starter',
              createdAtEpoch: 1735689600000,
            ),
          ],
          onAdminCredentialsUpdated: _noopAdminCredentials,
          onParentAdded: _noopParent,
          onParentUpdated: _noopParent,
          onParentDeleted: _noopParentDelete,
          onChildAdded: _noopChild,
          onChildUpdated: _noopChild,
          onChildDeleted: _noopChildDelete,
          onResetKidProgress: _noopReset,
          onOpenThemePicker: _noopOpenTheme,
          onExit: _noopExit,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Admin Control Center'), findsOneWidget);
    expect(find.text('Parent Users'), findsOneWidget);
    final Finder scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Kid Users'),
      280,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    expect(find.text('Kid Users'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Lectures & Quiz Control'),
      280,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    expect(find.text('Lectures & Quiz Control'), findsOneWidget);
  });
}

void _noopAdminCredentials(String email, String password) {}

void _noopParent(ParentAccount parent) {}

bool _noopParentDelete(String parentId) => true;

void _noopChild(ChildAccount child) {}

void _noopChildDelete(String childId) {}

Future<int> _noopReset() async => 0;

void _noopOpenTheme(BuildContext context) {}

void _noopExit(BuildContext context) {}
