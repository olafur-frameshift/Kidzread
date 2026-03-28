/// Accuracy thresholds for star awards.
const int kThreeStarPercent = 80;
const int kTwoStarPercent = 50;

/// Immutable snapshot of progress for a single profile.
class AppProgress {
  const AppProgress({
    this.starsPerLevel = const {},
    this.completedModules = const [],
    this.unlockedGames = const [],
  });

  /// Maps levelId → star count (1–3).
  final Map<String, int> starsPerLevel;

  /// IDs of fully completed modules.
  final List<String> completedModules;

  /// IDs of mini-games that have been unlocked.
  final List<String> unlockedGames;

  int get totalStars => starsPerLevel.values.fold(0, (a, b) => a + b);

  /// Returns 0 if the level has not been attempted.
  int starsForLevel(String levelId) => starsPerLevel[levelId] ?? 0;

  bool isModuleCompleted(String moduleId) => completedModules.contains(moduleId);

  bool isGameUnlocked(String gameId) => unlockedGames.contains(gameId);

  /// Returns 1–3 stars based on [accuracyPercent].
  static int starsForAccuracy(int accuracyPercent) {
    if (accuracyPercent >= kThreeStarPercent) return 3;
    if (accuracyPercent >= kTwoStarPercent) return 2;
    return 1;
  }

  AppProgress copyWith({
    Map<String, int>? starsPerLevel,
    List<String>? completedModules,
    List<String>? unlockedGames,
  }) {
    return AppProgress(
      starsPerLevel: starsPerLevel ?? Map.of(this.starsPerLevel),
      completedModules: completedModules ?? List.of(this.completedModules),
      unlockedGames: unlockedGames ?? List.of(this.unlockedGames),
    );
  }

  /// Serialise to a plain map suitable for SharedPreferences.
  Map<String, dynamic> toJson() {
    return {
      'starsPerLevel': starsPerLevel.map((k, v) => MapEntry(k, v.toString())),
      'completedModules': completedModules,
      'unlockedGames': unlockedGames,
    };
  }

  factory AppProgress.fromJson(Map<String, dynamic> json) {
    final rawStars = json['starsPerLevel'] as Map<String, dynamic>? ?? {};
    return AppProgress(
      starsPerLevel: rawStars.map((k, v) => MapEntry(k, int.parse(v as String))),
      completedModules: List<String>.from(json['completedModules'] as List? ?? []),
      unlockedGames: List<String>.from(json['unlockedGames'] as List? ?? []),
    );
  }
}

/// Profile-scoped container — single profile for MVP; list-ready for later.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.avatarAsset = 'assets/images/avatars/default.png',
    this.progress = const AppProgress(),
  });

  final String id;
  final String name;
  final String avatarAsset;
  final AppProgress progress;

  UserProfile copyWith({
    String? name,
    String? avatarAsset,
    AppProgress? progress,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarAsset': avatarAsset,
      'progress': progress.toJson(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarAsset: json['avatarAsset'] as String? ?? 'assets/images/avatars/default.png',
      progress: AppProgress.fromJson(
        (json['progress'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }
}
