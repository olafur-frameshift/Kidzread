import 'package:flutter_test/flutter_test.dart';
import 'package:kidsread/models/lesson.dart';

void main() {
  group('ModuleCatalogue', () {
    test('contains exactly 5 modules in progression order', () {
      expect(ModuleCatalogue.modules.length, equals(5));
      expect(ModuleCatalogue.modules[0].id, equals(ModuleIds.letters));
      expect(ModuleCatalogue.modules[4].id, equals(ModuleIds.wordPicture));
    });

    test('each module has 5 levels', () {
      for (final module in ModuleCatalogue.modules) {
        expect(module.levels.length, equals(5),
            reason: '${module.title} should have 5 levels');
      }
    });

    test('first module has no prerequisite', () {
      expect(ModuleCatalogue.modules.first.prerequisiteModuleId, isNull);
    });

    test('matching module unlocks letterSort', () {
      final matching = ModuleCatalogue.modules
          .firstWhere((m) => m.id == ModuleIds.matching);
      expect(matching.unlock, equals(ModuleUnlock.letterSort));
    });

    test('phonics module has no game unlock', () {
      final phonics = ModuleCatalogue.modules
          .firstWhere((m) => m.id == ModuleIds.phonics);
      expect(phonics.unlock, equals(ModuleUnlock.none));
    });
  });
}
