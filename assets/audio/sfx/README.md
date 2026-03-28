# UI Sound Effects

Short (< 500ms) audio clips for interactive feedback.

| Filename | Trigger |
|---|---|
| `tap.mp3` | Any button tap |
| `drag_start.mp3` | Drag gesture begins |
| `drop.mp3` | Letter/card dropped |
| `correct.mp3` | Correct answer |
| `wrong.mp3` | Wrong answer |
| `level_complete.mp3` | Level finished |
| `unlock.mp3` | Game unlock notification |
| `star_earned.mp3` | Star awarded |

## Sources

Free SFX: freesound.org, zapsplat.com (licensed for commercial use).
Wire clips into `TtsAudioService.playSfx()` via `just_audio` in Phase 1 polish.
