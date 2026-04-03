import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme.dart';
import '../../models/game.dart';
import '../../shared/widgets/big_button.dart';
import '../../shared/widgets/star_burst.dart';

/// Modal overlay shown when a level is completed.
///
/// Displays stars earned, any newly unlocked game, and offers a "Next" or
/// "Done" action.
class LevelCompleteOverlay extends StatelessWidget {
  const LevelCompleteOverlay({
    super.key,
    required this.stars,
    required this.onNext,
    this.isLastLevel = false,
    this.unlockedGameId,
  });

  final int stars;
  final VoidCallback onNext;
  final bool isLastLevel;

  /// Non-null if a mini-game was just unlocked.
  final String? unlockedGameId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(KidsReadTheme.spacingXL),
        decoration: BoxDecoration(
          color: KidsReadTheme.surfaceWhite,
          borderRadius: KidsReadTheme.radiusLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastLevel ? 'Module Complete!' : 'Level Done!',
              style: KidsReadTheme.displayMedium.copyWith(
                color: KidsReadTheme.primaryBlue,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(begin: const Offset(0.7, 0.7), duration: 400.ms, curve: Curves.elasticOut),

            const SizedBox(height: KidsReadTheme.spacingXL),

            StarBurst(starCount: stars, size: 52)
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: KidsReadTheme.spacingXL),

            Text(
              stars == 3
                  ? 'Perfect! ⭐⭐⭐'
                  : stars == 2
                      ? 'Great job!'
                      : 'Well done!',
              style: KidsReadTheme.headingMedium,
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 300.ms),

            // Game unlock announcement
            if (unlockedGameId != null) ...[
              const SizedBox(height: KidsReadTheme.spacingL),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: KidsReadTheme.spacingL,
                  vertical: KidsReadTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: KidsReadTheme.primaryYellow.withOpacity(0.2),
                  borderRadius: KidsReadTheme.radiusMedium,
                  border: Border.all(
                    color: KidsReadTheme.primaryYellow,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sports_esports_rounded,
                      color: KidsReadTheme.primaryOrange,
                      size: 28,
                    ),
                    const SizedBox(width: KidsReadTheme.spacingS),
                    Flexible(
                      child: Text(
                        'New game unlocked: ${_gameName(unlockedGameId!)}!',
                        style: KidsReadTheme.headingMedium.copyWith(
                          fontSize: 16,
                          color: KidsReadTheme.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 400.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    delay: 900.ms,
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  ),
            ],

            const SizedBox(height: KidsReadTheme.spacingXL),

            BigButton(
              label: isLastLevel ? 'Finish' : 'Next Level',
              onTap: onNext,
              color: KidsReadTheme.primaryGreen,
            )
                .animate()
                .fadeIn(delay: (unlockedGameId != null ? 1200 : 800).ms, duration: 300.ms)
                .slideY(begin: 0.3, delay: (unlockedGameId != null ? 1200 : 800).ms, duration: 300.ms),
          ],
        ),
      ),
    );
  }

  static String _gameName(String gameId) {
    return GameCatalogue.games
        .where((g) => g.id == gameId)
        .map((g) => g.title)
        .firstOrNull ?? 'a game';
  }
}
