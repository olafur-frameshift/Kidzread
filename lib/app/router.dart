import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/modules/letters/letters_module_screen.dart';
import '../features/modules/matching/matching_module_screen.dart';
import '../features/modules/phonics/phonics_module_screen.dart';
import '../features/modules/spelling/spelling_module_screen.dart';
import '../features/modules/word_picture/word_picture_module_screen.dart';
import '../features/games/bubble_pop/bubble_pop_screen.dart';
import '../features/games/letter_sort/letter_sort_screen.dart';
import '../features/games/word_builder/word_builder_screen.dart';
import '../features/games/picture_hunt/picture_hunt_screen.dart';
import '../features/profile/profile_screen.dart';

/// Named route constants — use these instead of raw strings.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String profile = '/profile';

  // Modules
  static const String lettersModule = '/modules/letters';
  static const String matchingModule = '/modules/matching';
  static const String phonicsModule = '/modules/phonics';
  static const String spellingModule = '/modules/spelling';
  static const String wordPictureModule = '/modules/word-picture';

  // Mini-games
  static const String bubblePop = '/games/bubble-pop';
  static const String letterSort = '/games/letter-sort';
  static const String wordBuilder = '/games/word-builder';
  static const String pictureHunt = '/games/picture-hunt';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),

    // --- Learning Modules ---
    GoRoute(
      path: AppRoutes.lettersModule,
      builder: (context, state) => const LettersModuleScreen(),
    ),
    GoRoute(
      path: AppRoutes.matchingModule,
      builder: (context, state) => const MatchingModuleScreen(),
    ),
    GoRoute(
      path: AppRoutes.phonicsModule,
      builder: (context, state) => const PhonicsModuleScreen(),
    ),
    GoRoute(
      path: AppRoutes.spellingModule,
      builder: (context, state) => const SpellingModuleScreen(),
    ),
    GoRoute(
      path: AppRoutes.wordPictureModule,
      builder: (context, state) => const WordPictureModuleScreen(),
    ),

    // --- Mini-Games ---
    GoRoute(
      path: AppRoutes.bubblePop,
      builder: (context, state) => const BubblePopScreen(),
    ),
    GoRoute(
      path: AppRoutes.letterSort,
      builder: (context, state) => const LetterSortScreen(),
    ),
    GoRoute(
      path: AppRoutes.wordBuilder,
      builder: (context, state) => const WordBuilderScreen(),
    ),
    GoRoute(
      path: AppRoutes.pictureHunt,
      builder: (context, state) => const PictureHuntScreen(),
    ),
  ],
);
