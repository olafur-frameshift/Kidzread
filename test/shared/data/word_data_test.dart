import 'package:flutter_test/flutter_test.dart';
import 'package:kidsread/shared/data/word_data.dart';

void main() {
  group('cvcWords', () {
    test('contains at least 20 words', () {
      expect(cvcWords.length, greaterThanOrEqualTo(20));
    });

    test('all words are 3 letters long (CVC)', () {
      for (final word in cvcWords) {
        expect(word.text.length, equals(3),
            reason: '"${word.text}" should be 3 letters');
      }
    });

    test('all words have an imageAsset path', () {
      for (final word in cvcWords) {
        expect(word.imageAsset, isNotEmpty);
        expect(word.imageAsset, startsWith('assets/images/words/'));
      }
    });

    test('no duplicate words', () {
      final texts = cvcWords.map((w) => w.text).toList();
      final unique = texts.toSet();
      expect(texts.length, equals(unique.length));
    });
  });

  group('sightWords', () {
    test('contains at least 20 sight words', () {
      expect(sightWords.length, greaterThanOrEqualTo(20));
    });

    test('all sight words are non-empty strings', () {
      for (final word in sightWords) {
        expect(word, isNotEmpty);
      }
    });
  });
}
