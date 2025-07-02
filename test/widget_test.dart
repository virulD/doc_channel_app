// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:doc_channel_app/main.dart';

void main() {
  testWidgets('App should start with landing screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the landing screen is displayed
    expect(find.text('MediBook'), findsOneWidget);
    expect(find.text('Find Your Nearest Dispensary'), findsOneWidget);
    expect(find.text('Choose Your Platform'), findsOneWidget);
    expect(find.text('Android'), findsOneWidget);
    expect(find.text('iOS'), findsOneWidget);
  });
}
