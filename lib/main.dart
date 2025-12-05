import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(
    // Wrap app with ProviderScope for Riverpod state management
    const ProviderScope(
      child: TeaTimerApp(),
    ),
  );
}

/// Main application widget
class TeaTimerApp extends StatelessWidget {
  const TeaTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tea Timer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TimerScreen(),
    );
  }
}
