# ABC & 123 — Learn to Write

A personal iPhone/iPad app that teaches a child how to write letters and
numbers by tracing them with a finger — inspired by LeapFrog's
*Mr. Pencil's Scribble & Write*.

<p>
  <em>Built with SwiftUI. No third-party dependencies, no ads, no network
  access — everything runs on the device.</em>
</p>

## What's inside

- **Big Letters (A–Z)**, **Small Letters (a–z)**, and **Numbers (0–9)**,
  each with proper handwriting stroke order.
- **Watch, then trace**: an animated pencil ✏️ demonstrates each character,
  then the child traces the gray track with a finger. Numbered green
  bubbles show where each stroke starts, direction arrows point the way
  along the stroke, and each stroke fills in with a different crayon color.
- **Phonics sticker rewards**: finishing a character earns a collectible
  sticker tied to its sound — "A is for apple 🍎", "B is for bear 🐻" —
  spoken aloud to reinforce letter sounds. Numbers earn counted sets
  ("Three apples 🍎🍎🍎"). Collected stickers live in a Sticker Book on
  the home screen.
- **Forgiving for little fingers**: generous touch tolerance, but the
  tracer still requires following the path — no skipping ahead or
  scribbling across the letter.
- **Rewards**: haptics while tracing, confetti + a big star on completion,
  and a friendly voice (system speech, no recordings needed) that
  announces each character and praises the child by name of the letter.
- **Stars**: each character collects up to 3 stars, saved on the device
  and shown in the picker grid.
- **Doodle mode**: a free-drawing scribble pad with a crayon palette,
  undo, and clear.
- A speaker button on the home screen mutes the voice; the gear button
  lets a grown-up reset all stars.

### Making the voice sound its best

The app speaks with the nicest voice installed on the device — it
automatically prefers Apple's premium and enhanced voices over the
default robotic one. For a noticeably warmer, more natural voice, do
this once on each phone: **Settings → Accessibility → Spoken Content →
Voices → English**, then download **Ava (Premium)** or
**Samantha (Enhanced)**. The app (and the web version in Safari) will
find and use it automatically.

## Getting it on your iPhones

You need a Mac with **Xcode 16 or newer** (free on the Mac App Store) and
an Apple ID.

1. Clone this repo and open `AlphaNumChild.xcodeproj` in Xcode.
2. Select the **AlphaNumChild** target → **Signing & Capabilities**:
   - Check **Automatically manage signing**.
   - Choose your **Team** (add your Apple ID under
     Xcode → Settings → Accounts if it's not listed).
   - Change the **Bundle Identifier** to something unique to you, e.g.
     `com.yourlastname.AlphaNumChild`.
3. Plug in your iPhone (or use Wi-Fi debugging), pick it as the run
   destination, and press **Run** (⌘R).
   - On the phone you may need to enable **Settings → Privacy & Security →
     Developer Mode**, then trust your developer certificate under
     **Settings → General → VPN & Device Management**.
4. Repeat step 3 with your wife's iPhone. Done — the app runs entirely
   offline from then on.

### Good to know about signing

- With a **free** Apple ID, apps you install this way expire after
  **7 days**; just plug in and press Run again to refresh them.
- With a **paid** Apple Developer account ($99/yr), installs last a year,
  and you could also distribute to both phones over the air via TestFlight.

## Project layout

```
AlphaNumChild/
├── AlphaNumChildApp.swift        App entry point
├── Models/
│   ├── PathBuilder.swift         Helpers for authoring stroke paths
│   ├── StrokeData+Uppercase.swift  A–Z stroke definitions
│   ├── StrokeData+Lowercase.swift  a–z stroke definitions
│   ├── StrokeData+Numbers.swift    0–9 stroke definitions
│   ├── TraceCharacter.swift      Character/stroke models + categories
│   └── TraceEngine.swift         Tracing validation + pencil demo
├── Support/
│   ├── ProgressStore.swift       Star persistence
│   ├── SpeechCoach.swift         Voice prompts and praise
│   └── Haptics.swift             Haptic feedback
└── Views/
    ├── HomeView.swift            Home menu
    ├── CharacterGridView.swift   Character picker with stars
    ├── TracingView.swift         Tracing screen + celebration
    ├── TracingCanvasView.swift   The tracing surface
    ├── ConfettiView.swift        Celebration confetti
    └── DoodleView.swift          Free-draw scribble pad
```

Every character is defined as ordered strokes in a normalized coordinate
space (see `StrokeData+*.swift`), so tweaking a shape or adding new ones
(shapes, more characters) only means editing data, not logic.
