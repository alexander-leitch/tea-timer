/// Constants for the Tea Timer app
class AppConstants {
  // Timer durations in seconds
  static const int threeMinutes = 180; // 3 minutes
  static const int fiveMinutes = 300; // 5 minutes
  
  // Available timer options
  static const List<TimerOption> timerOptions = [
    TimerOption(
      duration: threeMinutes,
      label: '3 Minutes',
      subtitle: 'Green Tea',
    ),
    TimerOption(
      duration: fiveMinutes,
      label: '5 Minutes',
      subtitle: 'Black Tea',
    ),
  ];
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
}

/// Represents a timer option with duration and labels
class TimerOption {
  final int duration;
  final String label;
  final String subtitle;
  
  const TimerOption({
    required this.duration,
    required this.label,
    required this.subtitle,
  });
}
