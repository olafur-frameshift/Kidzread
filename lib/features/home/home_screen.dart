import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../models/lesson.dart';
import '../../models/game.dart';
import '../../shared/progress/progress_service.dart';
import '../../shared/widgets/star_burst.dart';
import 'widgets/module_path_node.dart';
import 'widgets/game_card.dart';

/// The main home screen showing the module progression path and unlocked games.
///
/// Navigation is entirely icon- and audio-driven — no reading required.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(context),
            _buildModulePath(context),
            _buildGamesSection(context),
            const SliverToBoxAdapter(
              child: SizedBox(height: KidsReadTheme.spacingXXL),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final progress = context.watch<ProgressService>();
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(KidsReadTheme.spacingL),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [KidsReadTheme.primaryBlue, Color(0xFF5C6BC0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KidsRead',
                  style: KidsReadTheme.displayMedium.copyWith(
                    color: KidsReadTheme.surfaceWhite,
                  ),
                ),
                // Profile icon
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundColor: KidsReadTheme.primaryYellow,
                    child: Icon(
                      Icons.face_rounded,
                      size: 30,
                      color: KidsReadTheme.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: KidsReadTheme.spacingS),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: KidsReadTheme.starGold, size: 22),
                const SizedBox(width: KidsReadTheme.spacingXS),
                Text(
                  '${progress.totalStars} stars',
                  style: KidsReadTheme.bodyLarge.copyWith(
                    color: KidsReadTheme.surfaceWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulePath(BuildContext context) {
    final progressService = context.watch<ProgressService>();
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KidsReadTheme.spacingL,
          vertical: KidsReadTheme.spacingXL,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learning Path', style: KidsReadTheme.headingLarge),
            const SizedBox(height: KidsReadTheme.spacingL),
            ...ModuleCatalogue.modules.asMap().entries.map((entry) {
              final index = entry.key;
              final module = entry.value;
              final isLocked = progressService.isModuleLocked(module);
              final isCompleted =
                  progressService.isModuleCompleted(module.id);

              // Alternate nodes left/right for a winding path feel.
              final isRight = index.isEven;

              return ModulePathNode(
                module: module,
                isLocked: isLocked,
                isCompleted: isCompleted,
                alignRight: isRight,
                onTap: isLocked ? null : () => _navigateToModule(context, module),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesSection(BuildContext context) {
    final progressService = context.watch<ProgressService>();
    final anyUnlocked = GameCatalogue.games
        .any((g) => progressService.isGameUnlocked(g.id));

    if (!anyUnlocked) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: KidsReadTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Games', style: KidsReadTheme.headingLarge),
            const SizedBox(height: KidsReadTheme.spacingM),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: KidsReadTheme.spacingM,
              mainAxisSpacing: KidsReadTheme.spacingM,
              childAspectRatio: 1.1,
              children: GameCatalogue.games
                  .where((g) => progressService.isGameUnlocked(g.id))
                  .map((game) => GameCard(
                        game: game,
                        onTap: () => context.push(game.route),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, ModuleInfo module) {
    final routes = {
      'module_letters': '/modules/letters',
      'module_matching': '/modules/matching',
      'module_phonics': '/modules/phonics',
      'module_spelling': '/modules/spelling',
      'module_word_picture': '/modules/word-picture',
    };
    final route = routes[module.id];
    if (route != null) context.push(route);
  }
}
