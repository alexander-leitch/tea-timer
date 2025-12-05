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
    
    // Verify control buttons are always visible (inactive when no timer)
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets('Control buttons toggle and remain visible', (WidgetTester tester) async {
    // Build our app with generous screen size
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(const ProviderScope(child: TeaTimerApp()));

    // Tap on the 3-minute duration
    await tester.tap(find.text('3 Minutes'));
    await tester.pumpAndSettle();

    // Verify the timer shows 03:00 initially
    expect(find.text('03:00'), findsOneWidget);
    
    // Both control buttons should be visible
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Pause'), findsOneWidget); // Shows Pause when running
    
    // Duration selectors should STILL be visible
    expect(find.text('3 Minutes'), findsOneWidget);
    expect(find.text('5 Minutes'), findsOneWidget);
    
    // Pause the timer
    await tester.tap(find.text('Pause'));
    await tester.pumpAndSettle();
    
    // Button should toggle to Resume
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Pause'), findsNothing);
    
    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });
}
