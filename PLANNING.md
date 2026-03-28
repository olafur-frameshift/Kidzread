# KidsRead — Project Planning Document

## Overview

A native Android app for children aged 5–7 (Kindergarten–Grade 1) learning to read from scratch. Children progress through structured learning modules, with unlockable mini-games as rewards for completing each module. Audio is central to the experience — every interaction is voiced.

**Target audience:** Children aged 5–7, absolute reading beginners
**Platform:** Android (Flutter — expandable to iOS later)
**Tech stack:** Flutter + Dart

---

## Tech Stack Rationale

Flutter was chosen for the following reasons:

- Excellent Android support with a single codebase that can later expand to iOS
- Strong animation primitives, essential for a child-friendly, engaging UI
- Good audio packages (`just_audio`, `audioplayers`, `flutter_tts`)
- Fast, smooth rendering at 60fps on mid-range Android devices
- Easy to build touch-friendly, large-target UIs suited to small hands

---

## Repository Structure

```
kidsread/
├── README.md
├── PLANNING.md
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── router.dart               # Navigation / routing
│   │   └── theme.dart                # Colours, fonts, design tokens
│   ├── features/
│   │   ├── home/                     # Home screen, module path UI
│   │   ├── modules/
│   │   │   ├── letters/              # Module 1: Letter Recognition
│   │   │   ├── matching/             # Module 2: Uppercase / Lowercase Matching
│   │   │   ├── phonics/              # Module 3: Letter Sounds & Phonics
│   │   │   ├── spelling/             # Module 4: Short Word Spelling
│   │   │   └── word_picture/         # Module 5: Word–Picture Matching
│   │   ├── games/
│   │   │   ├── bubble_pop/           # Mini-game 1
│   │   │   ├── letter_sort/          # Mini-game 2
│   │   │   ├── word_builder/         # Mini-game 3
│   │   │   └── picture_hunt/         # Mini-game 4
│   │   └── profile/                  # Single profile now; multi-profile scaffold later
│   ├── shared/
│   │   ├── audio/                    # AudioService — TTS, SFX, music
│   │   ├── progress/                 # ProgressService — stars, unlocks, persistence
│   │   ├── widgets/                  # Reusable: BigButton, StarBurst, LetterCard, etc.
│   │   └── data/                     # Word lists, letter data, asset references
│   └── models/
│       ├── lesson.dart
│       ├── progress.dart
│       └── game.dart
├── assets/
│   ├── audio/
│   │   ├── letters/                  # Letter name + sound clips (or TTS)
│   │   ├── words/                    # Word pronunciation clips
│   │   ├── encouragement/            # "Great job!", "Try again!", etc.
│   │   ├── sfx/                      # Tap, drag, correct, wrong, level complete
│   │   └── music/                    # Soft looping background track
│   ├── images/
│   │   └── words/                    # One image per word in the word bank
│   └── fonts/                        # Fredoka One or Nunito
├── test/
└── docs/
    ├── content-wordlist.md           # Full word bank with CVC + sight words
    └── audio-script.md               # Script for recorded encouragement clips
```

---

## Learning Modules

Each module contains approximately 5 levels. Completing a module awards stars and unlocks a mini-game.

### Module 1 — Letter Recognition

- Display a letter, speak its name aloud; child taps to hear it again
- "Which letter is this?" — 4-choice tap quiz
- Uppercase and lowercase introduced together as a pair
- A → Z progression with periodic review rounds

**Unlock:** Bubble Pop mini-game

### Module 2 — Uppercase / Lowercase Matching

- Drag an uppercase letter to its lowercase counterpart
- Card-flip matching game style
- Letter pairs randomised each round

**Unlock:** Letter Sort mini-game

### Module 3 — Letter Sounds & Phonics

- Hear a sound, pick the correct letter from 3 options
- "What sound does B make?" with audio and an animated mouth-shape hint
- Short vowels introduced with extra emphasis

*(No additional unlock — bridges to Module 4)*

### Module 4 — Short Word Spelling (CVC Words)

- Word shown as a picture; child drags letters into blank slots to spell it
- Word bank: cat, dog, sun, hat, pig, cup, hen, bed, fox, jug, etc.
- Audio pronounces the completed word when all slots are filled

**Unlock:** Word Builder mini-game

### Module 5 — Word–Picture Matching

- Hear a word, tap the correct picture from a choice of 4
- Then reversed: see a word written, tap the correct picture
- Word bank: common Dolch/sight words + CVC words

**Unlock:** Picture Hunt mini-game

---

## Mini-Games

All mini-games have no fail state — they are purely for fun and replay value. Once unlocked, they are always accessible from the home screen.

| Game | Unlocked After | Description |
|---|---|---|
| **Bubble Pop** | Module 1 | Letters drift upward as bubbles — tap the one the voice names before it floats away |
| **Letter Sort** | Module 2 | Letters fall from the top — drag each into the correct uppercase or lowercase bin |
| **Word Builder** | Module 4 | Scrambled letters appear — arrange them to spell the pictured word before time runs out |
| **Picture Hunt** | Module 5 | A busy illustrated scene; a word is read aloud and the child taps the matching object |

---

## Audio Design

Audio is essential to this app. Every interaction must have a corresponding sound.

### Audio Assets Required

| Category | Description | Approximate Count |
|---|---|---|
| Letter names | "A", "B", "C" … | 26 clips |
| Letter sounds | The phoneme each letter makes | 26 clips |
| Word pronunciations | One clip per word in the word bank | ~100 clips |
| Encouragement | "Great job!", "Wow!", "Try again!", "Almost!" | 10–15 clips |
| UI sound effects | Tap, drag-start, drop, correct, wrong, level complete, unlock | ~8 clips |
| Background music | Soft, looping, child-friendly instrumental | 1 track |

### TTS Strategy (MVP)

For MVP, use `flutter_tts` to synthesise letter names, letter sounds, and word pronunciations. This avoids recording ~150 clips before launch. Recorded encouragement clips should be prioritised for warmth, or sourced from a voice actor.

Swap TTS for real recordings incrementally in later releases.

### Audio Service Interface

```dart
abstract class AudioService {
  Future<void> speakLetter(String letter);         // e.g. "A"
  Future<void> speakLetterSound(String letter);    // e.g. /æ/ sound
  Future<void> speakWord(String word);
  Future<void> playEncouragement(EncouragementType type);
  Future<void> playSfx(SfxType type);
  Future<void> playBackgroundMusic();
  Future<void> stopBackgroundMusic();
  void setMusicEnabled(bool enabled);
}
```

---

## Progress & Unlock System

Progress is persisted locally using `shared_preferences` for MVP. Migrate to `hive` if data complexity grows.

```dart
// models/progress.dart
class AppProgress {
  final Map<String, int> starsPerLevel;       // levelId -> 1..3
  final List<String> completedModules;
  final List<String> unlockedGames;
  int get totalStars => starsPerLevel.values.fold(0, (a, b) => a + b);
}
```

### Unlock Logic

- Each level awards 1–3 stars based on accuracy (≥ 80% = 3 stars, ≥ 50% = 2 stars, completed = 1 star)
- Completing the final level of a module triggers: confetti animation → voice congratulation → game unlock notification
- All unlocked games are accessible from a "Games" section on the home screen

### Multi-Profile (Future)

The data model should be profile-scoped from the start:

```dart
class UserProfile {
  final String id;
  final String name;
  final String avatarAsset;
  final AppProgress progress;
}
```

Store a `List<UserProfile>` even in MVP — just only expose one profile in the UI. This avoids a migration later.

---

## Content: Word Bank

### CVC Words (Module 4 + 5)

cat, dog, sun, hat, pig, cup, hen, bed, fox, jug, map, net, pin, rod, tub, van, web, yak, zip, bus, cot, fig, hop, inn, jet, kit, log, mud, nap, oak

### Dolch Sight Words (Module 5)

the, and, is, in, it, of, to, a, I, you, he, she, we, go, do, on, up, at, no, so, me, my, by, be, as

### Word Bank Data Model

```dart
class Word {
  final String text;
  final String imageAsset;   // 'assets/images/words/cat.png'
  final String? audioAsset;  // null = use TTS fallback
}
```

---

## UX & Design Guidelines

### Layout

- **Portrait orientation only** — simpler layout, more stable in small hands
- **Large touch targets** — minimum 60×60dp for all interactive elements
- **No reading required to navigate** — icons and audio guide all navigation
- **Short sessions** — each level completable in 2–3 minutes

### Visual Style

- High contrast, primary colours — simple, uncluttered backgrounds
- Chunky, rounded fonts — Fredoka One or Nunito
- Bright, friendly illustrations for word images (OpenMoji or Twemoji for MVP; commission custom art later)
- Smooth animations for all state transitions (correct answer, level complete, unlock)

### Feedback Philosophy

- **No penalty for wrong answers** — gentle audio cue ("Try again!") and the element wiggles
- **Immediate positive reinforcement** — correct answers trigger a small animation + sound every time
- **No timers in learning modules** — timers only appear in mini-games where they add fun, not stress
- **No reading required for instructions** — all instructions are spoken aloud

---

## Development Phases

### Phase 1 — Foundation

- Flutter project setup with routing, theme, and folder structure
- `AudioService` implementation with `flutter_tts` + SFX
- `ProgressService` with local persistence
- Home screen with a visual module path (lock/unlock states)

### Phase 2 — Core Learning Modules (1–3)

- Module 1: Letter Recognition
- Module 2: Uppercase/Lowercase Matching
- Module 3: Letter Sounds & Phonics
- Star award flow per level
- Module completion celebration animation

### Phase 3 — Word Modules (4–5)

- Module 4: Short Word Spelling (letter drag-and-drop)
- Module 5: Word–Picture Matching
- Full image asset library for word bank

### Phase 4 — Mini-Games

- Bubble Pop
- Letter Sort
- Word Builder
- Picture Hunt
- Unlock flow integrated with module completion

### Phase 5 — Polish & Hardening

- Recorded encouragement audio clips
- Onboarding flow for first-time launch
- Accessibility audit (text size, contrast ratios, semantic labels)
- Multi-profile data model scaffolded (UI remains single-profile)
- Offline-first verification — app must work fully without network

---

## Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_tts: ^4.0.0          # Text-to-speech for letters and words
  just_audio: ^0.9.0            # Background music and audio clips
  shared_preferences: ^2.0.0   # Progress persistence (MVP)
  hive: ^2.0.0                  # Optional: richer local storage if needed
  hive_flutter: ^1.0.0
  go_router: ^13.0.0            # Navigation
  provider: ^6.0.0              # State management
  lottie: ^3.0.0                # Celebration / confetti animations
  flutter_animate: ^4.0.0       # General UI animations

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## Out of Scope for MVP

The following are explicitly deferred and should not be designed around in the initial implementation:

- Backend / cloud sync
- Multiple user profiles (data model only — no UI)
- Parental dashboard or progress reports
- In-app purchases
- iOS support
- Languages other than English
- Adaptive difficulty (fixed progression for now)

---

## Open Questions

1. **Image art style** — use emoji-style assets (OpenMoji) for MVP, or commission a simple flat-illustration style from the start?
2. **Encouragement voice** — synthesised (flutter_tts) throughout, or record a small set of human clips for warmth?
3. **Minimum Android SDK version** — recommend API 21 (Android 5.0) for broadest device support; confirm acceptable.
4. **App name / branding** — "KidsRead" is a working title; finalise before any store submission.
