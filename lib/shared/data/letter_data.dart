/// Metadata for a single letter of the alphabet.
class LetterData {
  const LetterData({
    required this.letter,
    required this.phoneme,
    required this.exampleWord,
    required this.exampleImageAsset,
  });

  /// Uppercase form, e.g. 'A'.
  final String letter;

  /// Human-readable phoneme hint, e.g. 'æ' or 'buh'.
  final String phoneme;

  /// A simple CVC or common word starting with this letter.
  final String exampleWord;

  /// Image illustrating the example word.
  final String exampleImageAsset;

  String get lowercase => letter.toLowerCase();
}

/// Full A–Z letter catalogue.
const List<LetterData> alphabet = [
  LetterData(letter: 'A', phoneme: 'æ', exampleWord: 'apple', exampleImageAsset: 'assets/images/words/apple.png'),
  LetterData(letter: 'B', phoneme: 'buh', exampleWord: 'bus', exampleImageAsset: 'assets/images/words/bus.png'),
  LetterData(letter: 'C', phoneme: 'kuh', exampleWord: 'cat', exampleImageAsset: 'assets/images/words/cat.png'),
  LetterData(letter: 'D', phoneme: 'duh', exampleWord: 'dog', exampleImageAsset: 'assets/images/words/dog.png'),
  LetterData(letter: 'E', phoneme: 'eh', exampleWord: 'egg', exampleImageAsset: 'assets/images/words/egg.png'),
  LetterData(letter: 'F', phoneme: 'fuh', exampleWord: 'fox', exampleImageAsset: 'assets/images/words/fox.png'),
  LetterData(letter: 'G', phoneme: 'guh', exampleWord: 'jug', exampleImageAsset: 'assets/images/words/jug.png'),
  LetterData(letter: 'H', phoneme: 'huh', exampleWord: 'hat', exampleImageAsset: 'assets/images/words/hat.png'),
  LetterData(letter: 'I', phoneme: 'ih', exampleWord: 'inn', exampleImageAsset: 'assets/images/words/inn.png'),
  LetterData(letter: 'J', phoneme: 'juh', exampleWord: 'jet', exampleImageAsset: 'assets/images/words/jet.png'),
  LetterData(letter: 'K', phoneme: 'kuh', exampleWord: 'kit', exampleImageAsset: 'assets/images/words/kit.png'),
  LetterData(letter: 'L', phoneme: 'luh', exampleWord: 'log', exampleImageAsset: 'assets/images/words/log.png'),
  LetterData(letter: 'M', phoneme: 'muh', exampleWord: 'map', exampleImageAsset: 'assets/images/words/map.png'),
  LetterData(letter: 'N', phoneme: 'nuh', exampleWord: 'net', exampleImageAsset: 'assets/images/words/net.png'),
  LetterData(letter: 'O', phoneme: 'oh', exampleWord: 'oak', exampleImageAsset: 'assets/images/words/oak.png'),
  LetterData(letter: 'P', phoneme: 'puh', exampleWord: 'pig', exampleImageAsset: 'assets/images/words/pig.png'),
  LetterData(letter: 'Q', phoneme: 'kwuh', exampleWord: 'quiz', exampleImageAsset: 'assets/images/words/quiz.png'),
  LetterData(letter: 'R', phoneme: 'ruh', exampleWord: 'rod', exampleImageAsset: 'assets/images/words/rod.png'),
  LetterData(letter: 'S', phoneme: 'suh', exampleWord: 'sun', exampleImageAsset: 'assets/images/words/sun.png'),
  LetterData(letter: 'T', phoneme: 'tuh', exampleWord: 'tub', exampleImageAsset: 'assets/images/words/tub.png'),
  LetterData(letter: 'U', phoneme: 'uh', exampleWord: 'up', exampleImageAsset: 'assets/images/words/up.png'),
  LetterData(letter: 'V', phoneme: 'vuh', exampleWord: 'van', exampleImageAsset: 'assets/images/words/van.png'),
  LetterData(letter: 'W', phoneme: 'wuh', exampleWord: 'web', exampleImageAsset: 'assets/images/words/web.png'),
  LetterData(letter: 'X', phoneme: 'ksuh', exampleWord: 'box', exampleImageAsset: 'assets/images/words/box.png'),
  LetterData(letter: 'Y', phoneme: 'yuh', exampleWord: 'yak', exampleImageAsset: 'assets/images/words/yak.png'),
  LetterData(letter: 'Z', phoneme: 'zuh', exampleWord: 'zip', exampleImageAsset: 'assets/images/words/zip.png'),
];

/// Letters grouped by the five module levels (≈5 letters per level).
const List<List<String>> letterGroups = [
  ['A', 'B', 'C', 'D', 'E'],
  ['F', 'G', 'H', 'I', 'J'],
  ['K', 'L', 'M', 'N', 'O'],
  ['P', 'Q', 'R', 'S', 'T'],
  ['U', 'V', 'W', 'X', 'Y', 'Z'],
];
