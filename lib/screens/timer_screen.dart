import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../controllers/timer_controller.dart';
import '../services/sound_service.dart';
import '../widgets/circular_timer_painter.dart';
import '../widgets/duration_selector.dart';

/// Main timer screen displaying the countdown and controls
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});
  
  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  final SoundService _soundService = SoundService();
  
  @override
  void initState() {
    super.initState();
    
    // Listen for timer completion to play sound
    Future.microtask(() {
      ref.listenManual(
        timerControllerProvider,
        (previous, next) {
          if (previous?.status != TimerStatus.completed &&
              next.status == TimerStatus.completed) {
            // Timer just completed
            _soundService.playCompletionSound();
            _showCompletionDialog();
          }
        },
      );
    });
  }
  
  /// Show completion dialog when timer finishes
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '🍵 Tea is Ready!',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Your tea has been perfectly steeped.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(timerControllerProvider.notifier).reset();
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerControllerProvider);
    final timerController = ref.read(timerControllerProvider.notifier);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                const SizedBox(height: 16),
                Text(
                  'Tea Timer',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Steep your tea to perfection',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                
                const SizedBox(height: 24),
                
                // Duration selector (only show when idle)
                if (timerState.status == TimerStatus.idle)
                  DurationSelector(
                    selectedDuration: timerState.selectedDuration == 0
                        ? null
                        : timerState.selectedDuration,
                    onDurationSelected: (duration) {
                      // Select duration and immediately start the timer
                      timerController.selectDuration(duration);
                      // Auto-start after a brief delay to allow state update
                      Future.delayed(const Duration(milliseconds: 100), () {
                        timerController.start();
                      });
                    },
                  ),
                
                const SizedBox(height: 40),
                
                // Circular timer visualization
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Custom painted circular timer
                      CustomPaint(
                        size: const Size(240, 240),
                        painter: CircularTimerPainter(
                          progress: timerState.progress,
                          backgroundColor: AppTheme.secondaryColor.withOpacity(0.3),
                          progressColor: timerState.status == TimerStatus.completed
                              ? AppTheme.accentColor
                              : AppTheme.timerActive,
                          strokeWidth: 16,
                        ),
                      ),
                      
                      // Time display in center
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timerState.formattedTime,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 56,
                                ),
                          ),
                          if (timerState.status != TimerStatus.idle)
                            Text(
                              _getStatusText(timerState.status),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Control buttons
                _buildControlButtons(timerState, timerController),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build control buttons based on timer status
  Widget _buildControlButtons(TimerState state, TimerController controller) {
    if (state.selectedDuration == 0) {
      // No duration selected
      return const SizedBox.shrink();
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button (always show when duration is selected)
        if (state.status != TimerStatus.idle)
          _CircularButton(
            icon: Icons.refresh,
            onPressed: controller.reset,
            backgroundColor: AppTheme.secondaryColor,
            foregroundColor: AppTheme.textPrimary,
          ),
        
        if (state.status != TimerStatus.idle) const SizedBox(width: 16),
        
        // Main action button (Start/Pause/Resume)
        _CircularButton(
          icon: _getMainButtonIcon(state.status),
          onPressed: () => _handleMainButtonPress(state, controller),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          size: 80,
          iconSize: 36,
        ),
      ],
    );
  }
  
  /// Get the icon for the main action button
  IconData _getMainButtonIcon(TimerStatus status) {
    switch (status) {
      case TimerStatus.idle:
      case TimerStatus.completed:
        return Icons.play_arrow;
      case TimerStatus.running:
        return Icons.pause;
      case TimerStatus.paused:
        return Icons.play_arrow;
    }
  }
  
  /// Handle main button press based on current status
  void _handleMainButtonPress(TimerState state, TimerController controller) {
    switch (state.status) {
      case TimerStatus.idle:
      case TimerStatus.completed:
        controller.start();
        break;
      case TimerStatus.running:
        controller.pause();
        break;
      case TimerStatus.paused:
        controller.resume();
        break;
    }
  }
  
  /// Get status text for display
  String _getStatusText(TimerStatus status) {
    switch (status) {
      case TimerStatus.idle:
        return 'Ready';
      case TimerStatus.running:
        return 'Steeping...';
      case TimerStatus.paused:
        return 'Paused';
      case TimerStatus.completed:
        return 'Completed!';
    }
  }
}

/// Circular button widget for controls
class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;
  final double iconSize;
  
  const _CircularButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.size = 64,
    this.iconSize = 28,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(size / 2),
      elevation: 4,
      shadowColor: backgroundColor.withOpacity(0.4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: foregroundColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
