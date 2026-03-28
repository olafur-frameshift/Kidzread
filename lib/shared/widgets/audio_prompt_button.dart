import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../audio/audio_service.dart';

/// A large speaker button that plays audio when tapped.
///
/// Used throughout modules to let children replay the current prompt.
class AudioPromptButton extends StatefulWidget {
  const AudioPromptButton({
    super.key,
    required this.onTap,
    this.size = KidsReadTheme.minTouchTarget + 16,
    this.color = KidsReadTheme.primaryBlue,
  });

  /// Called when the button is tapped. Trigger your AudioService call here.
  final VoidCallback onTap;
  final double size;
  final Color color;

  @override
  State<AudioPromptButton> createState() => _AudioPromptButtonState();
}

class _AudioPromptButtonState extends State<AudioPromptButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() => _isPlaying = true);
    _pulseController.repeat(reverse: true);
    widget.onTap();
    // Reset after a short delay (real completion callback can be wired later).
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isPlaying = false);
        _pulseController.stop();
        _pulseController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.4),
              blurRadius: _isPlaying ? 20 : 8,
              spreadRadius: _isPlaying ? 4 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.volume_up_rounded : Icons.volume_up_outlined,
          color: KidsReadTheme.surfaceWhite,
          size: widget.size * 0.45,
        ),
      )
          .animate(controller: _pulseController, autoPlay: false)
          .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 600.ms),
    );
  }
}
