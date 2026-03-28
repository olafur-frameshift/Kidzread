import 'package:flutter_test/flutter_test.dart';
import 'package:kidsread/models/progress.dart';

void main() {
  group('AppProgress', () {
    test('totalStars sums starsPerLevel', () {
      const progress = AppProgress(starsPerLevel: {
        'level_a': 3,
        'level_b': 2,
        'level_c': 1,
      });
      expect(progress.totalStars, equals(6));
    });

    test('totalStars is 0 for empty progress', () {
      const progress = AppProgress();
      expect(progress.totalStars, equals(0));
    });

    test('starsForAccuracy returns 3 at 80%', () {
      expect(AppProgress.starsForAccuracy(80), equals(3));
      expect(AppProgress.starsForAccuracy(100), equals(3));
    });

    test('starsForAccuracy returns 2 at 50–79%', () {
      expect(AppProgress.starsForAccuracy(50), equals(2));
      expect(AppProgress.starsForAccuracy(79), equals(2));
    });

    test('starsForAccuracy returns 1 below 50%', () {
      expect(AppProgress.starsForAccuracy(0), equals(1));
      expect(AppProgress.starsForAccuracy(49), equals(1));
    });

    test('isModuleCompleted returns false when not completed', () {
      const progress = AppProgress();
      expect(progress.isModuleCompleted('module_letters'), isFalse);
    });

    test('isModuleCompleted returns true after module added', () {
      const progress = AppProgress(completedModules: ['module_letters']);
      expect(progress.isModuleCompleted('module_letters'), isTrue);
    });

    test('isGameUnlocked returns false when locked', () {
      const progress = AppProgress();
      expect(progress.isGameUnlocked('game_bubble_pop'), isFalse);
    });

    test('isGameUnlocked returns true after unlock', () {
      const progress = AppProgress(unlockedGames: ['game_bubble_pop']);
      expect(progress.isGameUnlocked('game_bubble_pop'), isTrue);
    });

    test('copyWith preserves unchanged fields', () {
      const original = AppProgress(
        starsPerLevel: {'a': 2},
        completedModules: ['mod_a'],
        unlockedGames: ['game_a'],
      );
      final copy = original.copyWith(starsPerLevel: {'a': 3});
      expect(copy.completedModules, equals(['mod_a']));
      expect(copy.unlockedGames, equals(['game_a']));
      expect(copy.starsPerLevel['a'], equals(3));
    });

    test('serialises and deserialises to/from JSON', () {
      const original = AppProgress(
        starsPerLevel: {'level_1': 3, 'level_2': 1},
        completedModules: ['module_letters'],
        unlockedGames: ['game_bubble_pop'],
      );
      final json = original.toJson();
      final restored = AppProgress.fromJson(json);

      expect(restored.totalStars, equals(original.totalStars));
      expect(restored.completedModules, equals(original.completedModules));
      expect(restored.unlockedGames, equals(original.unlockedGames));
    });
  });

  group('UserProfile', () {
    test('default profile has empty progress', () {
      const profile = UserProfile(id: 'test', name: 'Reader');
      expect(profile.progress.totalStars, equals(0));
    });

    test('copyWith updates name', () {
      const profile = UserProfile(id: 'test', name: 'Reader');
      final updated = profile.copyWith(name: 'Alice');
      expect(updated.name, equals('Alice'));
      expect(updated.id, equals('test'));
    });

    test('serialises and deserialises to/from JSON', () {
      const profile = UserProfile(
        id: 'abc',
        name: 'Bobby',
        progress: AppProgress(starsPerLevel: {'x': 2}),
      );
      final json = profile.toJson();
      final restored = UserProfile.fromJson(json);
      expect(restored.id, equals('abc'));
      expect(restored.name, equals('Bobby'));
      expect(restored.progress.totalStars, equals(2));
    });
  });
}
