import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme.dart';

/// Displays a row of 1–3 stars, animating them in on first render.
class StarBurst extends StatelessWidget {
  const StarBurst({
    super.key,
    required this.starCount,
    this.size = 40,
  }) : assert(starCount >= 0 && starCount <= 3);

  final int starCount;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final earned = index < starCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: KidsReadTheme.spacingXS),
          child: Icon(
            earned ? Icons.star_rounded : Icons.star_border_rounded,
            color: earned ? KidsReadTheme.starGold : KidsReadTheme.lockedGrey,
            size: size,
          )
              .animate(delay: Duration(milliseconds: 150 * index))
              .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 300.ms, curve: Curves.elasticOut)
              .fade(),
        );
      }),
    );
  }
}
