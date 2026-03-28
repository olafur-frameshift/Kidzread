/// All words used across Modules 4 and 5.
///
/// [audioAsset] is null → TTS fallback via AudioService.speakWord().
/// Add real recorded clips later by populating audioAsset paths.
class Word {
  const Word({
    required this.text,
    required this.imageAsset,
    this.audioAsset,
  });

  final String text;

  /// Path relative to project root, e.g. 'assets/images/words/cat.png'
  final String imageAsset;

  /// If null, flutter_tts will synthesise the pronunciation.
  final String? audioAsset;
}

/// CVC (consonant-vowel-consonant) words used in Module 4 and 5.
const List<Word> cvcWords = [
  Word(text: 'cat', imageAsset: 'assets/images/words/cat.png'),
  Word(text: 'dog', imageAsset: 'assets/images/words/dog.png'),
  Word(text: 'sun', imageAsset: 'assets/images/words/sun.png'),
  Word(text: 'hat', imageAsset: 'assets/images/words/hat.png'),
  Word(text: 'pig', imageAsset: 'assets/images/words/pig.png'),
  Word(text: 'cup', imageAsset: 'assets/images/words/cup.png'),
  Word(text: 'hen', imageAsset: 'assets/images/words/hen.png'),
  Word(text: 'bed', imageAsset: 'assets/images/words/bed.png'),
  Word(text: 'fox', imageAsset: 'assets/images/words/fox.png'),
  Word(text: 'jug', imageAsset: 'assets/images/words/jug.png'),
  Word(text: 'map', imageAsset: 'assets/images/words/map.png'),
  Word(text: 'net', imageAsset: 'assets/images/words/net.png'),
  Word(text: 'pin', imageAsset: 'assets/images/words/pin.png'),
  Word(text: 'rod', imageAsset: 'assets/images/words/rod.png'),
  Word(text: 'tub', imageAsset: 'assets/images/words/tub.png'),
  Word(text: 'van', imageAsset: 'assets/images/words/van.png'),
  Word(text: 'web', imageAsset: 'assets/images/words/web.png'),
  Word(text: 'yak', imageAsset: 'assets/images/words/yak.png'),
  Word(text: 'zip', imageAsset: 'assets/images/words/zip.png'),
  Word(text: 'bus', imageAsset: 'assets/images/words/bus.png'),
  Word(text: 'cot', imageAsset: 'assets/images/words/cot.png'),
  Word(text: 'fig', imageAsset: 'assets/images/words/fig.png'),
  Word(text: 'hop', imageAsset: 'assets/images/words/hop.png'),
  Word(text: 'jet', imageAsset: 'assets/images/words/jet.png'),
  Word(text: 'kit', imageAsset: 'assets/images/words/kit.png'),
  Word(text: 'log', imageAsset: 'assets/images/words/log.png'),
  Word(text: 'mud', imageAsset: 'assets/images/words/mud.png'),
  Word(text: 'nap', imageAsset: 'assets/images/words/nap.png'),
];

/// Dolch sight words used in Module 5.
/// These have no picture asset — they use text-display matching exercises.
const List<String> sightWords = [
  'the', 'and', 'is', 'in', 'it',
  'of', 'to', 'a', 'I', 'you',
  'he', 'she', 'we', 'go', 'do',
  'on', 'up', 'at', 'no', 'so',
  'me', 'my', 'by', 'be', 'as',
];
