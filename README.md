# KidsRead

A native Android app for children aged 5–7 (Kindergarten–Grade 1) learning to read from scratch. Children progress through structured learning modules, with unlockable mini-games as rewards for completing each module. Audio is central to the experience — every interaction is voiced.

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Android SDK (API 21+, Android 5.0 minimum)
- A device or emulator running Android 5.0+

### Running the App

```bash
flutter pub get
flutter run
```

### Running Tests

```bash
flutter test
```

## Project Structure

```
lib/
├── main.dart               # App entry point
├── app/
│   ├── router.dart         # go_router navigation
│   └── theme.dart          # Colours, fonts, design tokens
├── features/
│   ├── home/               # Home screen & module path UI
│   ├── modules/
│   │   ├── letters/        # Module 1: Letter Recognition
│   │   ├── matching/       # Module 2: Uppercase/Lowercase Matching
│   │   ├── phonics/        # Module 3: Letter Sounds & Phonics
│   │   ├── spelling/       # Module 4: Short Word Spelling
│   │   └── word_picture/   # Module 5: Word–Picture Matching
│   ├── games/
│   │   ├── bubble_pop/     # Mini-game 1
│   │   ├── letter_sort/    # Mini-game 2
│   │   ├── word_builder/   # Mini-game 3
│   │   └── picture_hunt/   # Mini-game 4
│   └── profile/            # Single profile (multi-profile scaffold)
├── shared/
│   ├── audio/              # AudioService
│   ├── progress/           # ProgressService
│   ├── widgets/            # Reusable widgets
│   └── data/               # Word lists, letter data
└── models/                 # Data models
```

## Learning Modules

| Module | Topic | Unlock |
|--------|-------|--------|
| 1 | Letter Recognition | Bubble Pop game |
| 2 | Uppercase/Lowercase Matching | Letter Sort game |
| 3 | Letter Sounds & Phonics | — |
| 4 | Short Word Spelling (CVC) | Word Builder game |
| 5 | Word–Picture Matching | Picture Hunt game |

## Tech Stack

- **Framework:** Flutter (Dart)
- **Audio:** `flutter_tts` (TTS) + `just_audio` (clips & music)
- **Navigation:** `go_router`
- **State:** `provider`
- **Persistence:** `shared_preferences` (MVP)
- **Animations:** `lottie` + `flutter_animate`

See [PLANNING.md](PLANNING.md) for the full project planning document.
