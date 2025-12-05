import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/theme.dart';

/// Widget for selecting a timer duration with beautiful card UI
class DurationSelector extends StatelessWidget {
  final int? selectedDuration;
  final Function(int) onDurationSelected;
  
  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onDurationSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppConstants.timerOptions.map((option) {
        final isSelected = selectedDuration == option.duration;
        
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _DurationCard(
              option: option,
              isSelected: isSelected,
              onTap: () => onDurationSelected(option.duration),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Individual duration card widget
class _DurationCard extends StatefulWidget {
  final TimerOption option;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _DurationCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  State<_DurationCard> createState() => _DurationCardState();
}

class _DurationCardState extends State<_DurationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.shortAnimation,
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
    _controller.forward();
  }
  
  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }
  
  void _handleTapCancel() {
    _controller.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: AppConstants.mediumAnimation,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: widget.isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Timer duration label
              Text(
                widget.option.label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: widget.isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).textTheme.titleLarge?.color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle (tea type)
              Text(
                widget.option.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.isSelected
                          ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
