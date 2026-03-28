# KidsRead — Audio Script

All lines are intended for a warm, clear, friendly voice suitable for children aged 5–7.
Speech rate: slow and deliberate. Tone: encouraging, never patronising.

---

## Encouragement Clips

Record these first — they have the most emotional impact on the child's experience.

| File | Script | Notes |
|------|--------|-------|
| `great_job.mp3` | "Great job!" | Bright, enthusiastic |
| `wow.mp3` | "Wow, amazing!" | Excited, high energy |
| `try_again.mp3` | "Try again!" | Gentle, supportive — not disappointed |
| `almost_there.mp3` | "Almost there!" | Encouraging, building momentum |
| `level_complete.mp3` | "You finished the level! Fantastic!" | Celebratory |
| `game_unlocked.mp3` | "You unlocked a new game! Let's play!" | Exciting, reward-focused |

---

## UI Prompts (TTS fallback text — record later for warmth)

These are synthesised by `flutter_tts` in MVP. Script them here for future recording.

### Module 1 — Letter Recognition
- "Which letter is this?"
- "Tap the letter!"
- "Tap to hear the letter again."

### Module 2 — Uppercase / Lowercase Matching
- "Match the big letter to the small letter!"
- "Drag the big letter to its little twin."

### Module 3 — Letter Sounds & Phonics
- "What sound does this letter make?"
- "Tap to hear the sound again."
- "Which letter is it?"

### Module 4 — Short Word Spelling
- "Spell the word!"
- "Drag the letters into the right spots."
- "Tap a letter to put it back."

### Module 5 — Word–Picture Matching
- "Tap the matching picture!"
- "Tap to hear the word again."

---

## Letter Names (A–Z)

TTS handles these automatically. For future recorded clips, record each letter
name as it is spoken in the English alphabet ("ay", "bee", "see", …).

| Letter | Clip | Phonetic spelling |
|--------|------|------------------|
| A | a.mp3 | "ay" |
| B | b.mp3 | "bee" |
| C | c.mp3 | "see" |
| D | d.mp3 | "dee" |
| E | e.mp3 | "ee" |
| F | f.mp3 | "ef" |
| G | g.mp3 | "jee" |
| H | h.mp3 | "aitch" |
| I | i.mp3 | "eye" |
| J | j.mp3 | "jay" |
| K | k.mp3 | "kay" |
| L | l.mp3 | "el" |
| M | m.mp3 | "em" |
| N | n.mp3 | "en" |
| O | o.mp3 | "oh" |
| P | p.mp3 | "pee" |
| Q | q.mp3 | "cue" |
| R | r.mp3 | "ar" |
| S | s.mp3 | "es" |
| T | t.mp3 | "tee" |
| U | u.mp3 | "you" |
| V | v.mp3 | "vee" |
| W | w.mp3 | "double-you" |
| X | x.mp3 | "ex" |
| Y | y.mp3 | "why" |
| Z | z.mp3 | "zee" |

---

## Letter Sounds (Phonemes)

Short, isolated phoneme sounds — no schwa added where avoidable.

| Letter | Phoneme | Notes |
|--------|---------|-------|
| A | /æ/ | Short 'a' as in "cat" |
| B | /b/ | Brief, no trailing vowel |
| C | /k/ | Hard 'c' only for MVP |
| D | /d/ | |
| E | /ɛ/ | Short 'e' as in "bed" |
| F | /f/ | |
| G | /g/ | Hard 'g' as in "go" |
| H | /h/ | Breathed, not "huh" |
| I | /ɪ/ | Short 'i' as in "pig" |
| J | /dʒ/ | |
| K | /k/ | |
| L | /l/ | |
| M | /m/ | |
| N | /n/ | |
| O | /ɒ/ | Short 'o' as in "fox" |
| P | /p/ | |
| Q | /kw/ | |
| R | /r/ | |
| S | /s/ | |
| T | /t/ | |
| U | /ʌ/ | Short 'u' as in "cup" |
| V | /v/ | |
| W | /w/ | |
| X | /ks/ | |
| Y | /j/ | |
| Z | /z/ | |

---

## Production Notes

- Record in a quiet room; use a pop filter.
- Sample rate: 44.1 kHz, mono, 16-bit.
- Normalise to −3 dBFS peak.
- Export as MP3 (128 kbps) for mobile; keep WAV masters.
- Name files exactly as listed — the code references them by filename.
