import 'package:flutter_test/flutter_test.dart';
import 'package:kidsread/shared/data/letter_data.dart';

void main() {
  group('alphabet', () {
    test('contains exactly 26 letters', () {
      expect(alphabet.length, equals(26));
    });

    test('letters are A–Z in order', () {
      for (int i = 0; i < alphabet.length; i++) {
        expect(alphabet[i].letter, equals(String.fromCharCode(65 + i)));
      }
    });

    test('all letters have a non-empty phoneme', () {
      for (final data in alphabet) {
        expect(data.phoneme, isNotEmpty,
            reason: '${data.letter} is missing a phoneme');
      }
    });

    test('lowercase is the lowercase of the letter', () {
      for (final data in alphabet) {
        expect(data.lowercase, equals(data.letter.toLowerCase()));
      }
    });
  });

  group('letterGroups', () {
    test('covers all 26 letters exactly once', () {
      final allLetters = letterGroups.expand((g) => g).toList();
      expect(allLetters.length, equals(26));
      expect(allLetters.toSet().length, equals(26));
    });

    test('contains 5 groups', () {
      expect(letterGroups.length, equals(5));
    });
  });
}
