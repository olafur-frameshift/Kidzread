import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../models/lesson.dart';
import '../../models/game.dart';
import '../../shared/progress/progress_service.dart';
import '../../shared/widgets/star_burst.dart';

/// Profile screen — single profile for MVP.
///
/// Displays the child's name, total stars, per-module progress, and unlocked
/// games. The data model already supports multiple profiles; only the UI is
/// single-profile for now.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ProgressService>();
    final profile = service.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: KidsReadTheme.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(KidsReadTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: KidsReadTheme.primaryYellow,
                    child: Icon(Icons.face_rounded,
                        size: 60, color: KidsReadTheme.textDark),
                  ),
                  const SizedBox(height: KidsReadTheme.spacingM),
                  Text(profile.name, style: KidsReadTheme.displayMedium),
                  const SizedBox(height: KidsReadTheme.spacingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: KidsReadTheme.starGold, size: 28),
                      const SizedBox(width: KidsReadTheme.spacingXS),
                      Text(
                        '${service.totalStars} stars earned',
                        style: KidsReadTheme.headingMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: KidsReadTheme.spacingXXL),
            Text('Learning Progress', style: KidsReadTheme.headingLarge),
            const SizedBox(height: KidsReadTheme.spacingM),

            // Module progress list
            ...ModuleCatalogue.modules.map((module) {
              final isCompleted = service.isModuleCompleted(module.id);
              final isLocked = service.isModuleLocked(module);
              final moduleStars = module.levels.fold<int>(
                0,
                (sum, level) => sum + service.starsForLevel(level.id),
              );
              final maxStars = module.levels.length * 3;

              return Container(
                margin:
                    const EdgeInsets.only(bottom: KidsReadTheme.spacingM),
                padding: const EdgeInsets.all(KidsReadTheme.spacingM),
                decoration: BoxDecoration(
                  color: KidsReadTheme.cardBackground,
                  borderRadius: KidsReadTheme.radiusMedium,
                  border: Border.all(
                    color: isCompleted
                        ? KidsReadTheme.correctGreen
                        : KidsReadTheme.lockedGrey,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isLocked
                          ? Icons.lock_rounded
                          : isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                      color: isLocked
                          ? KidsReadTheme.lockedGrey
                          : isCompleted
                              ? KidsReadTheme.correctGreen
                              : KidsReadTheme.primaryBlue,
                      size: 28,
                    ),
                    const SizedBox(width: KidsReadTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(module.title,
                              style: KidsReadTheme.headingMedium),
                          if (!isLocked)
                            Text(
                              '$moduleStars / $maxStars stars',
                              style: KidsReadTheme.bodyLarge.copyWith(
                                  color: KidsReadTheme.starGold),
                            ),
                          if (isLocked)
                            Text(
                              'Complete previous module to unlock',
                              style: KidsReadTheme.bodyLarge.copyWith(
                                  color: KidsReadTheme.lockedGrey,
                                  fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: KidsReadTheme.spacingL),
            Text('Games', style: KidsReadTheme.headingLarge),
            const SizedBox(height: KidsReadTheme.spacingM),

            // Games unlock status
            ...GameCatalogue.games.map((game) {
              final isUnlocked = service.isGameUnlocked(game.id);
              return Container(
                margin:
                    const EdgeInsets.only(bottom: KidsReadTheme.spacingM),
                padding: const EdgeInsets.all(KidsReadTheme.spacingM),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Color(game.color).withOpacity(0.12)
                      : KidsReadTheme.cardBackground,
                  borderRadius: KidsReadTheme.radiusMedium,
                  border: Border.all(
                    color: isUnlocked
                        ? Color(game.color)
                        : KidsReadTheme.lockedGrey,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isUnlocked
                          ? Icons.sports_esports_rounded
                          : Icons.lock_rounded,
                      color: isUnlocked
                          ? Color(game.color)
                          : KidsReadTheme.lockedGrey,
                      size: 28,
                    ),
                    const SizedBox(width: KidsReadTheme.spacingM),
                    Text(game.title, style: KidsReadTheme.headingMedium),
                    if (!isUnlocked) ...[
                      const Spacer(),
                      const Icon(Icons.lock_rounded,
                          color: KidsReadTheme.lockedGrey, size: 18),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
