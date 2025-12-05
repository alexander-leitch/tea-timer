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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
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
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Duration selector (always visible)
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
                        
                        // Spacer to push timer to center
                        const Spacer(),
                        
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
                                  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                  progressColor: timerState.status == TimerStatus.completed
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Theme.of(context).colorScheme.primary.withOpacity(0.8),
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
                                            fontSize: 14,
                                          ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Spacer to push controls to bottom
                        const Spacer(),
                        
                        // Control buttons at bottom
                        _buildControlButtons(timerState, timerController),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  /// Build control buttons based on timer status
  Widget _buildControlButtons(TimerState state, TimerController controller) {
    // Determine if buttons should be active
    final bool hasTimer = state.selectedDuration > 0;
    final bool isRunningOrPaused = state.status == TimerStatus.running || state.status == TimerStatus.paused;
    
    return Row(
      children: [
        // Reset button (always visible, active when timer exists)
        Expanded(
          child: _ControlCard(
            icon: Icons.refresh,
            label: 'Reset',
            onPressed: hasTimer ? controller.reset : null,
            isActive: hasTimer,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Pause/Resume toggle button (always visible, active when running or paused)
        Expanded(
          child: _ControlCard(
            icon: state.status == TimerStatus.running ? Icons.pause : Icons.play_arrow,
            label: state.status == TimerStatus.running ? 'Pause' : 'Resume',
            onPressed: isRunningOrPaused 
                ? (state.status == TimerStatus.running ? controller.pause : controller.resume)
                : null,
            isActive: isRunningOrPaused,
          ),
        ),
      ],
    );
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

/// Control card widget matching duration selector style
class _ControlCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isActive;
  
  const _ControlCard({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isActive = true,
  });
  
  @override
  State<_ControlCard> createState() => _ControlCardState();
}

class _ControlCardState extends State<_ControlCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTapDown(TapDownDetails details) {
    if (widget.isActive && widget.onPressed != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    if (widget.isActive && widget.onPressed != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onPressed!();
    }
  }
  
  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    // Calculate effective opacity and color based on state
    final double effectiveOpacity = widget.isActive ? 1.0 : 0.5;
    // Use a darkened surface color for pressed state in light mode, or a lightened one in dark mode
    final Color baseColor = Theme.of(context).colorScheme.surface;
    final Color pressedColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade200
        : Colors.white.withOpacity(0.1);
        
    return Opacity(
      opacity: effectiveOpacity,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: _isPressed ? pressedColor : baseColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  color: widget.isActive 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).disabledColor,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.isActive 
                        ? null 
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
