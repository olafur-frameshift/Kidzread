import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme.dart';

/// A large, tappable card displaying a single letter.
///
/// Plays a wiggle animation on wrong-answer feedback via [triggerWiggle].
class LetterCard extends StatefulWidget {
  const LetterCard({
    super.key,
    required this.letter,
    required this.onTap,
    this.backgroundColor,
    this.textColor = KidsReadTheme.textDark,
    this.size = 100,
    this.isSelected = false,
    this.isCorrect,
  });

  final String letter;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color textColor;
  final double size;

  /// Whether this card is currently selected by the child.
  final bool isSelected;

  /// null = not yet judged; true = correct; false = wrong.
  final bool? isCorrect;

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _wiggleController;

  @override
  void initState() {
    super.initState();
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _wiggleController.dispose();
    super.dispose();
  }

  void triggerWiggle() {
    _wiggleController.forward(from: 0);
  }

  Color get _cardColor {
    if (widget.isCorrect == true) return KidsReadTheme.correctGreen;
    if (widget.isCorrect == false) return KidsReadTheme.wrongRed;
    if (widget.isSelected) return KidsReadTheme.primaryBlue.withOpacity(0.85);
    return widget.backgroundColor ?? KidsReadTheme.cardBackground;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: KidsReadTheme.radiusMedium,
          boxShadow: [
            BoxShadow(
              color: _cardColor.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: widget.isSelected
              ? Border.all(color: KidsReadTheme.primaryBlue, width: 3)
              : null,
        ),
        child: Center(
          child: Text(
            widget.letter,
            style: KidsReadTheme.displayLarge.copyWith(
              color: widget.isCorrect != null || widget.isSelected
                  ? KidsReadTheme.surfaceWhite
                  : widget.textColor,
              fontSize: widget.size * 0.5,
            ),
          ),
        ),
      )
          .animate(controller: _wiggleController, autoPlay: false)
          .shakeX(amount: 6, duration: 400.ms),
    );
  }
}
