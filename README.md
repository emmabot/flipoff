# FlipOff.

**A kid-friendly split-flap display for your family TV.** Jokes, riddles, quotes, weather, and morning/bedtime routines — all in retro flip-board style.

🔴 **Live now:** [emmabot.github.io/flipoff](https://emmabot.github.io/flipoff/)

![FlipOff Screenshot](screenshot.png)

## What is this?

FlipOff turns any TV or monitor into a warm, clackety split-flap display — the kind you'd see at old train stations. It's built for families: kid-friendly jokes, riddles with delayed reveals, quotes from Star Wars and Percy Jackson, and time-aware reminders for morning routines and bedtime.

No accounts. No frameworks. No subscriptions. Just open it and go.

## What's on the board

- **207 jokes & puns** — kid-friendly, groan-worthy, parent-approved
- **30 riddles** — answer reveals after a 10-second pause
- **24 quotes** — Star Wars, Harry Potter, Percy Jackson, Greek & Norse mythology
- **Morning mode** (7–8am) — routine reminders + live weather for Berkeley, CA
- **Bedtime mode** (7:30–8:30pm) — wind-down reminders + calming quotes
- **Retro warm palette** — amber, coral, sky blue, sage, cream, lavender

## Quick Start

**Easiest:** Just open [emmabot.github.io/flipoff](https://emmabot.github.io/flipoff/) on your TV browser.

**Local:**
```bash
git clone https://github.com/emmabot/flipoff.git
cd flipoff
python3 -m http.server 8080
# Open http://localhost:8080
```

Press `F` for fullscreen. Click anywhere to enable sound.

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Enter` / `Space` | Next message |
| `←` / `→` | Previous / Next message |
| `F` | Toggle fullscreen |
| `M` | Toggle sound |
| `Escape` | Exit fullscreen |

## Apple TV (tvOS)

There's a native tvOS app in `tvos/` that loads content from the GitHub Pages site.

1. Open `tvos/FlipOff.xcodeproj` in Xcode
2. Build and deploy to your Apple TV
3. The app fetches content on launch — no rebuilds needed for content updates

## Customization

Everything lives in `js/constants.js`. Edit it to change:

- **Content** — jokes, riddles, quotes, morning/bedtime reminders
- **Time slots** — when morning and bedtime modes activate
- **Weather** — location for weather fetches
- **Grid size** — `GRID_COLS` and `GRID_ROWS`
- **Colors** — the warm retro palette
- **Timing** — scramble speed, stagger delay, rotation interval

Push to `main` and GitHub Pages auto-deploys. The tvOS app picks up changes on next launch.

## File Structure

```
flipoff/
  index.html              — Single-page app
  css/
    reset.css             — CSS reset
    layout.css            — Full-screen edge-to-edge layout
    board.css             — Board container and accent bars
    tile.css              — Tile styling (1.5× aspect ratio)
    responsive.css        — Media queries for all screen sizes
  js/
    main.js               — Entry point and UI wiring
    Board.js              — Grid manager and transition orchestration
    Tile.js               — Individual tile animation logic
    SoundEngine.js        — Audio playback with Web Audio API
    MessageRotator.js     — Content rotation and time-of-day routing
    KeyboardController.js — Keyboard shortcut handling
    constants.js          — All content, config, colors, time slots
    flapAudio.js          — Embedded flip sound (base64)
  tvos/
    FlipOff/              — Native tvOS app source
    FlipOff.xcodeproj     — Xcode project
```

## Tech

Pure vanilla HTML/CSS/JS. No frameworks, no build tools, no npm. Works offline (except weather).

## License

MIT — do whatever you want with it.
