// Widget tests for the Tea Timer app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_timer/main.dart';

void main() {
  testWidgets('Tea Timer app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    // Wrapped in ProviderScope for Riverpod
    await tester.pumpWidget(const ProviderScope(child: TeaTimerApp()));

    // Verify that our app loads with the correct title
    expect(find.text('Tea Timer'), findsOneWidget);
    expect(find.text('Steep your tea to perfection'), findsOneWidget);
    
    // Verify duration selector buttons are present
    expect(find.text('3 Minutes'), findsOneWidget);
    expect(find.text('5 Minutes'), findsOneWidget);
  });

  testWidgets('Duration selection works', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const ProviderScope(child: TeaTimerApp()));

    // Tap on the 3-minute duration
    await tester.tap(find.text('3 Minutes'));
    await tester.pumpAndSettle();

    // Verify the timer shows 03:00
    expect(find.text('03:00'), findsOneWidget);
    
    // Verify play button appears
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });
}
