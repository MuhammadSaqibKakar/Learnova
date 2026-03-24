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
}
