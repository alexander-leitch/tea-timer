import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum representing the current state of the timer
enum TimerStatus {
  idle,      // Timer hasn't been started
  running,   // Timer is actively counting down
  paused,    // Timer is paused
  completed, // Timer has finished
}

/// State class for the timer
class TimerState {
  final int selectedDuration; // Duration in seconds
  final int remainingTime;     // Remaining time in seconds
  final TimerStatus status;
  
  const TimerState({
    required this.selectedDuration,
    required this.remainingTime,
    required this.status,
  });
  
  /// Initial state
  factory TimerState.initial() {
    return const TimerState(
      selectedDuration: 0,
      remainingTime: 0,
      status: TimerStatus.idle,
    );
  }
  
  /// Get progress as a value between 0.0 and 1.0
  double get progress {
    if (selectedDuration == 0) return 0.0;
    return 1.0 - (remainingTime / selectedDuration);
  }
  
  /// Format remaining time as MM:SS
  String get formattedTime {
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Copy with method for immutable updates
  TimerState copyWith({
    int? selectedDuration,
    int? remainingTime,
    TimerStatus? status,
  }) {
    return TimerState(
      selectedDuration: selectedDuration ?? this.selectedDuration,
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
    );
  }
}

/// Timer controller using Riverpod
class TimerController extends StateNotifier<TimerState> {
  Timer? _timer;
  
  TimerController() : super(TimerState.initial());
  
  /// Select a timer duration (in seconds)
  void selectDuration(int duration) {
    // Stop any existing timer
    _timer?.cancel();
    
    state = TimerState(
      selectedDuration: duration,
      remainingTime: duration,
      status: TimerStatus.idle,
    );
  }
  
  /// Start the timer
  void start() {
    if (state.selectedDuration == 0) return;
    
    state = state.copyWith(status: TimerStatus.running);
    
    // Create a periodic timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(
          remainingTime: state.remainingTime - 1,
        );
      } else {
        // Timer completed
        _complete();
      }
    });
  }
  
  /// Pause the timer
  void pause() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }
  
  /// Resume the timer
  void resume() {
    start(); // Reuse the start logic
  }
  
  /// Reset the timer to the selected duration
  void reset() {
    _timer?.cancel();
    state = TimerState(
      selectedDuration: state.selectedDuration,
      remainingTime: state.selectedDuration,
      status: TimerStatus.idle,
    );
  }
  
  /// Called when timer completes
  void _complete() {
    _timer?.cancel();
    state = state.copyWith(
      remainingTime: 0,
      status: TimerStatus.completed,
    );
    
    // Trigger haptic feedback
    HapticFeedback.mediumImpact();
    
    // Note: Sound will be played in the UI layer
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider for the timer controller
final timerControllerProvider = StateNotifierProvider<TimerController, TimerState>((ref) {
  return TimerController();
});
