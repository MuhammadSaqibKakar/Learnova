import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnova/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  testWidgets('Learnova login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LearnovaApp());
    await tester.pump(const Duration(milliseconds: 3800));

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

  testWidgets('Dragging Dino does not scroll the page underneath', (
    WidgetTester tester,
  ) async {
    final ScrollController controller = ScrollController();
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      controller.dispose();
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DinoPageOverlay(
            message: 'Drag Dino',
            child: SingleChildScrollView(
              controller: controller,
              child: const SizedBox(
                height: 2200,
                child: Center(child: Text('Scrollable Page')),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final Finder dinoBubble = find.text('Drag Dino');
    expect(dinoBubble, findsOneWidget);
    final Offset initialCenter = tester.getCenter(dinoBubble);

    final TestGesture gesture = await tester.startGesture(initialCenter);
    await gesture.moveBy(const Offset(0, -160));
    await tester.pump();
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 250));

    expect(controller.offset, 0);
    final Offset movedCenter = tester.getCenter(dinoBubble);
    expect(movedCenter.dy, lessThan(initialCenter.dy - 40));

    final TestGesture secondGesture = await tester.startGesture(movedCenter);
    await secondGesture.moveBy(const Offset(-60, -40));
    await tester.pump();
    await secondGesture.up();
    await tester.pump(const Duration(milliseconds: 250));

    expect(controller.offset, 0);
    final Offset movedAgainCenter = tester.getCenter(dinoBubble);
    expect(movedAgainCenter.dx, lessThan(movedCenter.dx - 20));
    expect(movedAgainCenter.dy, lessThan(movedCenter.dy - 10));

    final TestGesture edgeGesture = await tester.startGesture(movedAgainCenter);
    await edgeGesture.moveBy(const Offset(-1000, -1000));
    await tester.pump();
    await edgeGesture.up();
    await tester.pump(const Duration(milliseconds: 250));

    expect(controller.offset, 0);
    final Offset edgeCenter = tester.getCenter(dinoBubble);
    expect(edgeCenter.dx, lessThan(140));
    expect(edgeCenter.dy, lessThan(140));
  });
}

void _noopChild(ChildAccount child) {}

void _noopDelete(String id) {}
