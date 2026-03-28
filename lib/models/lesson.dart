/// Module identifiers — used as keys in progress tracking.
class ModuleIds {
  ModuleIds._();

  static const String letters = 'module_letters';
  static const String matching = 'module_matching';
  static const String phonics = 'module_phonics';
  static const String spelling = 'module_spelling';
  static const String wordPicture = 'module_word_picture';

  static const List<String> all = [
    letters,
    matching,
    phonics,
    spelling,
    wordPicture,
  ];
}

/// The mini-game that a module unlocks, if any.
enum ModuleUnlock { none, bubblePop, letterSort, wordBuilder, pictureHunt }

/// Descriptor for a learning module shown on the home screen path.
class ModuleInfo {
  const ModuleInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.color,
    required this.levels,
    this.unlock = ModuleUnlock.none,
    this.prerequisiteModuleId,
  });

  final String id;
  final String title;
  final String description;

  /// Asset path for the module icon (used on the home path).
  final String iconAsset;

  /// Accent colour for this module's UI.
  final int color;

  /// The levels contained in this module, in order.
  final List<LevelInfo> levels;

  /// Mini-game unlocked on completing this module.
  final ModuleUnlock unlock;

  /// If set, this module is locked until the prerequisite is completed.
  final String? prerequisiteModuleId;
}

/// Descriptor for an individual level within a module.
class LevelInfo {
  const LevelInfo({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}

/// Static catalogue of all modules in progression order.
class ModuleCatalogue {
  ModuleCatalogue._();

  static const List<ModuleInfo> modules = [
    ModuleInfo(
      id: ModuleIds.letters,
      title: 'Letter Recognition',
      description: 'Learn the alphabet — tap each letter to hear its name!',
      iconAsset: 'assets/images/icons/module_letters.png',
      color: 0xFF2979FF,
      unlock: ModuleUnlock.bubblePop,
      levels: [
        LevelInfo(id: 'letters_1', title: 'A – E'),
        LevelInfo(id: 'letters_2', title: 'F – J'),
        LevelInfo(id: 'letters_3', title: 'K – O'),
        LevelInfo(id: 'letters_4', title: 'P – T'),
        LevelInfo(id: 'letters_5', title: 'U – Z + Review'),
      ],
    ),
    ModuleInfo(
      id: ModuleIds.matching,
      title: 'Big & Small Letters',
      description: 'Match each uppercase letter to its lowercase twin!',
      iconAsset: 'assets/images/icons/module_matching.png',
      color: 0xFFFF6D00,
      unlock: ModuleUnlock.letterSort,
      prerequisiteModuleId: ModuleIds.letters,
      levels: [
        LevelInfo(id: 'matching_1', title: 'A–E Pairs'),
        LevelInfo(id: 'matching_2', title: 'F–J Pairs'),
        LevelInfo(id: 'matching_3', title: 'K–O Pairs'),
        LevelInfo(id: 'matching_4', title: 'P–T Pairs'),
        LevelInfo(id: 'matching_5', title: 'U–Z Pairs + Review'),
      ],
    ),
    ModuleInfo(
      id: ModuleIds.phonics,
      title: 'Letter Sounds',
      description: 'Listen and pick the letter that makes each sound!',
      iconAsset: 'assets/images/icons/module_phonics.png',
      color: 0xFFAA00FF,
      prerequisiteModuleId: ModuleIds.matching,
      levels: [
        LevelInfo(id: 'phonics_1', title: 'Short Vowels'),
        LevelInfo(id: 'phonics_2', title: 'Consonants A–M'),
        LevelInfo(id: 'phonics_3', title: 'Consonants N–Z'),
        LevelInfo(id: 'phonics_4', title: 'Mixed Practice'),
        LevelInfo(id: 'phonics_5', title: 'Full Review'),
      ],
    ),
    ModuleInfo(
      id: ModuleIds.spelling,
      title: 'Spell It!',
      description: 'Drag letters into the right spots to spell the word!',
      iconAsset: 'assets/images/icons/module_spelling.png',
      color: 0xFF00C853,
      unlock: ModuleUnlock.wordBuilder,
      prerequisiteModuleId: ModuleIds.phonics,
      levels: [
        LevelInfo(id: 'spelling_1', title: 'CVC Words – Set 1'),
        LevelInfo(id: 'spelling_2', title: 'CVC Words – Set 2'),
        LevelInfo(id: 'spelling_3', title: 'CVC Words – Set 3'),
        LevelInfo(id: 'spelling_4', title: 'CVC Words – Set 4'),
        LevelInfo(id: 'spelling_5', title: 'Mixed Review'),
      ],
    ),
    ModuleInfo(
      id: ModuleIds.wordPicture,
      title: 'Word & Picture',
      description: 'Hear a word and tap the matching picture!',
      iconAsset: 'assets/images/icons/module_word_picture.png',
      color: 0xFFFF4081,
      unlock: ModuleUnlock.pictureHunt,
      prerequisiteModuleId: ModuleIds.spelling,
      levels: [
        LevelInfo(id: 'word_picture_1', title: 'CVC Words'),
        LevelInfo(id: 'word_picture_2', title: 'Sight Words – Set 1'),
        LevelInfo(id: 'word_picture_3', title: 'Sight Words – Set 2'),
        LevelInfo(id: 'word_picture_4', title: 'Mixed Words'),
        LevelInfo(id: 'word_picture_5', title: 'Full Review'),
      ],
    ),
  ];
}
