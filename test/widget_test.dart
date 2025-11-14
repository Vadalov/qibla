// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:islami_app/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IslamiApp());

    // Verify that the app shows the home screen with navigation items
    expect(find.text('Vakitler'), findsOneWidget);
    expect(find.text('Kıble'), findsOneWidget);
    expect(find.text('Kur\'an'), findsOneWidget);
    expect(find.text('Dua & Zikir'), findsOneWidget);
  });
}
