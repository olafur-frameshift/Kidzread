import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/progress.dart';
import '../../models/lesson.dart';
import '../../models/game.dart';

const String _kProfileKey = 'kidsread_profile';

/// Result returned from [ProgressService.recordLevelComplete].
class LevelResult {
  const LevelResult({required this.stars, this.unlockedGameId});

  /// Stars earned (1–3).
  final int stars;

  /// Non-null if a mini-game was just unlocked by completing the module.
  final String? unlockedGameId;
}

/// Manages loading, updating, and persisting the single active [UserProfile].
///
/// Exposes [ChangeNotifier] so widgets can rebuild on progress changes.
/// In MVP only one profile is active; the data model is already list-ready.
class ProgressService extends ChangeNotifier {
  late UserProfile _profile;
  late SharedPreferences _prefs;

  UserProfile get profile => _profile;
  AppProgress get progress => _profile.progress;

  /// Must be called once before any other method (called in main()).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _profile = _loadProfile();
  }

  // ---------------------------------------------------------------------------
  // Read helpers
  // ---------------------------------------------------------------------------

  int starsForLevel(String levelId) => progress.starsForLevel(levelId);

  bool isModuleCompleted(String moduleId) =>
      progress.isModuleCompleted(moduleId);

  bool isModuleLocked(ModuleInfo module) {
    final prereq = module.prerequisiteModuleId;
    if (prereq == null) return false;
    return !progress.isModuleCompleted(prereq);
  }

  bool isGameUnlocked(String gameId) => progress.isGameUnlocked(gameId);

  int get totalStars => progress.totalStars;

  // ---------------------------------------------------------------------------
  // Write helpers
  // ---------------------------------------------------------------------------

  /// Record the result of completing a level.
  ///
  /// [accuracyPercent] is 0–100. Returns a [LevelResult] with stars awarded
  /// and any newly unlocked game.
  Future<LevelResult> recordLevelComplete({
    required String levelId,
    required String moduleId,
    required int accuracyPercent,
    required bool isLastLevelInModule,
  }) async {
    final stars = AppProgress.starsForAccuracy(accuracyPercent);
    final currentBest = progress.starsForLevel(levelId);

    final updatedStars = Map<String, int>.of(progress.starsPerLevel);
    if (stars > currentBest) {
      updatedStars[levelId] = stars;
    }

    final updatedModules = List<String>.of(progress.completedModules);
    final updatedGames = List<String>.of(progress.unlockedGames);
    String? newlyUnlockedGame;

    if (isLastLevelInModule && !updatedModules.contains(moduleId)) {
      updatedModules.add(moduleId);

      // Determine which game (if any) this module unlocks.
      final module = ModuleCatalogue.modules
          .where((m) => m.id == moduleId)
          .firstOrNull;
      if (module != null) {
        final gameId = _gameIdForUnlock(module.unlock);
        if (gameId != null && !updatedGames.contains(gameId)) {
          updatedGames.add(gameId);
          newlyUnlockedGame = gameId;
        }
      }
    }

    final newProgress = progress.copyWith(
      starsPerLevel: updatedStars,
      completedModules: updatedModules,
      unlockedGames: updatedGames,
    );

    _profile = _profile.copyWith(progress: newProgress);
    await _persist();
    notifyListeners();

    return LevelResult(stars: stars, unlockedGameId: newlyUnlockedGame);
  }

  Future<void> updateProfileName(String name) async {
    _profile = _profile.copyWith(name: name);
    await _persist();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

  UserProfile _loadProfile() {
    final raw = _prefs.getString(_kProfileKey);
    if (raw == null) {
      return const UserProfile(id: 'default', name: 'Reader');
    }
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserProfile(id: 'default', name: 'Reader');
    }
  }

  Future<void> _persist() async {
    await _prefs.setString(_kProfileKey, jsonEncode(_profile.toJson()));
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  String? _gameIdForUnlock(ModuleUnlock unlock) {
    switch (unlock) {
      case ModuleUnlock.bubblePop:
        return GameIds.bubblePop;
      case ModuleUnlock.letterSort:
        return GameIds.letterSort;
      case ModuleUnlock.wordBuilder:
        return GameIds.wordBuilder;
      case ModuleUnlock.pictureHunt:
        return GameIds.pictureHunt;
      case ModuleUnlock.none:
        return null;
    }
  }
}
