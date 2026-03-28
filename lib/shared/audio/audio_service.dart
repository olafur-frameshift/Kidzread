import 'package:flutter_tts/flutter_tts.dart';

/// Phoneme hints for each letter (IPA-approximate English pronunciations).
const Map<String, String> _letterSoundHints = {
  'A': 'æ', 'B': 'buh', 'C': 'kuh', 'D': 'duh', 'E': 'eh',
  'F': 'fuh', 'G': 'guh', 'H': 'huh', 'I': 'ih', 'J': 'juh',
  'K': 'kuh', 'L': 'luh', 'M': 'muh', 'N': 'nuh', 'O': 'oh',
  'P': 'puh', 'Q': 'kwuh', 'R': 'ruh', 'S': 'suh', 'T': 'tuh',
  'U': 'uh', 'V': 'vuh', 'W': 'wuh', 'X': 'ksuh', 'Y': 'yuh',
  'Z': 'zuh',
};

/// Types of encouraging feedback the app can play.
enum EncouragementType {
  greatJob,
  wow,
  tryAgain,
  almostThere,
  levelComplete,
  gameUnlocked,
}

/// UI sound-effect categories.
enum SfxType {
  tap,
  dragStart,
  drop,
  correct,
  wrong,
  levelComplete,
  unlock,
  starEarned,
}

/// Contract for all audio interactions in KidsRead.
///
/// Every on-screen interaction should trigger a corresponding audio cue.
/// Implementations must be safe to call from widget build/event callbacks.
abstract class AudioService {
  Future<void> init();

  /// Speak the letter name aloud, e.g. "A" → "ay".
  Future<void> speakLetter(String letter);

  /// Speak the phoneme sound for [letter], e.g. "A" → /æ/.
  Future<void> speakLetterSound(String letter);

  /// Speak [word] aloud, e.g. "cat".
  Future<void> speakWord(String word);

  /// Play an encouragement phrase.
  Future<void> playEncouragement(EncouragementType type);

  /// Play a short UI sound effect.
  Future<void> playSfx(SfxType type);

  /// Start looping background music.
  Future<void> playBackgroundMusic();

  /// Stop background music.
  Future<void> stopBackgroundMusic();

  /// Toggle music on/off (persisted by caller via ProgressService).
  void setMusicEnabled(bool enabled);
}

/// TTS-backed implementation for MVP.
///
/// Uses [flutter_tts] for all speech. SFX and music playback are stubbed
/// and will be wired to `just_audio` in Phase 1 polish.
class TtsAudioService implements AudioService {
  final FlutterTts _tts = FlutterTts();
  bool _musicEnabled = true;

  @override
  Future<void> init() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45); // Slow, clear speech for young learners
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1); // Slightly higher pitch — friendly and clear
  }

  @override
  Future<void> speakLetter(String letter) async {
    await _tts.speak(letter.toUpperCase());
  }

  @override
  Future<void> speakLetterSound(String letter) async {
    final sound = _letterSoundHints[letter.toUpperCase()] ?? letter;
    await _tts.speak(sound);
  }

  @override
  Future<void> speakWord(String word) async {
    await _tts.speak(word);
  }

  @override
  Future<void> playEncouragement(EncouragementType type) async {
    final phrase = _encouragementText[type] ?? 'Great!';
    await _tts.speak(phrase);
  }

  @override
  Future<void> playSfx(SfxType type) async {
    // Stub: wire to just_audio in Phase 1 polish.
    // Clips will live under assets/audio/sfx/<type>.mp3
  }

  @override
  Future<void> playBackgroundMusic() async {
    // Stub: wire to just_audio in Phase 1 polish.
    // Track: assets/audio/music/background.mp3
  }

  @override
  Future<void> stopBackgroundMusic() async {
    // Stub.
  }

  @override
  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
  }

  static const Map<EncouragementType, String> _encouragementText = {
    EncouragementType.greatJob: 'Great job!',
    EncouragementType.wow: 'Wow, amazing!',
    EncouragementType.tryAgain: 'Try again!',
    EncouragementType.almostThere: 'Almost there!',
    EncouragementType.levelComplete: 'You finished the level! Fantastic!',
    EncouragementType.gameUnlocked: 'You unlocked a new game! Let\'s play!',
  };
}
