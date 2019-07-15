// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_code/main.dart';

void main() {
  testWidgets('Options page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(OptionsPageStateful());

    // Verify that our counter starts at 0.
    expect(find.byKey(Key('quit')), findsOneWidget);
    expect(find.byKey(Key('continue')), findsOneWidget);
  });

  testWidgets('Options page press keep using', (WidgetTester tester) async {
    await tester.pumpWidget(OptionsPageStateful());

    var continueBtn = find.byKey(Key('continue'));
    await tester.tap(continueBtn);
    expect(find.text("Yay!!"), findsNothing);
    expect(find.text("Awww!!"), findsNothing);
    await tester.pump();
    expect(find.text("Yay!!"), findsOneWidget);
    expect(find.text("Awww!!"), findsNothing);
  });

  testWidgets('Options page press ditch', (WidgetTester tester) async {
    await tester.pumpWidget(OptionsPageStateful());

    var quitBtn = find.byKey(Key('quit'));
    await tester.tap(quitBtn);
    expect(find.text("Yay!!"), findsNothing);
    expect(find.text("Awww!!"), findsNothing);
    await tester.pump();
    expect(find.text("Yay!!"), findsNothing);
    expect(find.text("Awww!!"), findsOneWidget);
  });
}
