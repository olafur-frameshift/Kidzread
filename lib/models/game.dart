/// Mini-game identifiers — used as keys in progress unlock tracking.
class GameIds {
  GameIds._();

  static const String bubblePop = 'game_bubble_pop';
  static const String letterSort = 'game_letter_sort';
  static const String wordBuilder = 'game_word_builder';
  static const String pictureHunt = 'game_picture_hunt';

  static const List<String> all = [
    bubblePop,
    letterSort,
    wordBuilder,
    pictureHunt,
  ];
}

/// Descriptor for a mini-game shown in the Games section.
class GameInfo {
  const GameInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.color,
    required this.route,
    required this.unlockedByModuleId,
  });

  final String id;
  final String title;
  final String description;
  final String iconAsset;

  /// Accent colour for the game card.
  final int color;

  /// go_router path to navigate to this game.
  final String route;

  /// The module that must be completed to unlock this game.
  final String unlockedByModuleId;
}

/// Static catalogue of all mini-games.
class GameCatalogue {
  GameCatalogue._();

  static const List<GameInfo> games = [
    GameInfo(
      id: GameIds.bubblePop,
      title: 'Bubble Pop',
      description: 'Pop the bubble with the letter you hear!',
      iconAsset: 'assets/images/icons/game_bubble_pop.png',
      color: 0xFF2979FF,
      route: '/games/bubble-pop',
      unlockedByModuleId: 'module_letters',
    ),
    GameInfo(
      id: GameIds.letterSort,
      title: 'Letter Sort',
      description: 'Sort falling letters into uppercase and lowercase bins!',
      iconAsset: 'assets/images/icons/game_letter_sort.png',
      color: 0xFFFF6D00,
      route: '/games/letter-sort',
      unlockedByModuleId: 'module_matching',
    ),
    GameInfo(
      id: GameIds.wordBuilder,
      title: 'Word Builder',
      description: 'Arrange the scrambled letters to spell the word!',
      iconAsset: 'assets/images/icons/game_word_builder.png',
      color: 0xFF00C853,
      route: '/games/word-builder',
      unlockedByModuleId: 'module_spelling',
    ),
    GameInfo(
      id: GameIds.pictureHunt,
      title: 'Picture Hunt',
      description: 'Find the object in the picture that matches the word!',
      iconAsset: 'assets/images/icons/game_picture_hunt.png',
      color: 0xFFFF4081,
      route: '/games/picture-hunt',
      unlockedByModuleId: 'module_word_picture',
    ),
  ];
}
