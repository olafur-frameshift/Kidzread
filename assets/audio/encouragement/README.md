# Encouragement Audio Clips

Record or source the following clips. Warm, friendly voice — child-appropriate.

| Filename | Text |
|---|---|
| `great_job.mp3` | "Great job!" |
| `wow.mp3` | "Wow, amazing!" |
| `try_again.mp3` | "Try again!" |
| `almost_there.mp3` | "Almost there!" |
| `level_complete.mp3` | "You finished the level! Fantastic!" |
| `game_unlocked.mp3` | "You unlocked a new game! Let's play!" |

## MVP

`flutter_tts` synthesises all clips automatically via `TtsAudioService`.
Swap in recorded files by setting `audioAsset` paths in `AudioService.playEncouragement()`.
