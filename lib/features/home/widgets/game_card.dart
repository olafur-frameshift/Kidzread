import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../models/game.dart';

/// A tappable card for an unlocked mini-game shown in the Games grid.
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  final GameInfo game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(game.color);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: KidsReadTheme.radiusLarge,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(KidsReadTheme.spacingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_esports_rounded,
              color: KidsReadTheme.surfaceWhite,
              size: 40,
            ),
            const SizedBox(height: KidsReadTheme.spacingS),
            Text(
              game.title,
              style: KidsReadTheme.headingMedium.copyWith(
                color: KidsReadTheme.surfaceWhite,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
