import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Service for handling sound effects and haptic feedback
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();
  
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  /// Play completion sound
  /// Note: In a production app, you would add an actual sound file to assets
  /// For now, we'll rely on haptic feedback
  Future<void> playCompletionSound() async {
    try {
      // Trigger strong haptic feedback
      await HapticFeedback.heavyImpact();
      
      // Wait a moment
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Trigger another light impact for a "pulse" effect
      await HapticFeedback.lightImpact();
      
      // In a real app, you would play a sound file like this:
      // await _audioPlayer.play(AssetSource('sounds/completion.mp3'));
    } catch (e) {
      // Silently fail if sound/haptic not available
    }
  }
  
  /// Play tick sound (optional for countdown)
  Future<void> playTickSound() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Silently fail
    }
  }
  
  /// Dispose of resources
  void dispose() {
    _audioPlayer.dispose();
  }
}
