# ZenSpace

Personal focus & notification manager for macOS. Lives in your menu bar, integrates with your notch.

![macOS 13+](https://img.shields.io/badge/macOS-13.0%2B-blue)
![Swift 5.10](https://img.shields.io/badge/Swift-5.10-orange)
![License MIT](https://img.shields.io/badge/license-MIT-green)

## Features

- 📅 **Calendar** — upcoming events (today/tomorrow) with colored indicators
- 🎵 **Now Playing** — media controls, artwork, metadata
- 🌙 **Focus Modes** — system DND detection with status indicator
- 🔋 **Battery** — level monitoring, low battery alerts with sound
- 🖥️ **BetterDisplay** — detection, launch observation, OSD
- 🔒 **Lock Screen Sounds** — audio feedback on lock/unlock
- 🔄 **Auto-update** — checks for new versions automatically

## Installation

```bash
curl -sL https://raw.githubusercontent.com/kamilpopowicz/ZenSpace/main/scripts/install.sh | bash
```

This downloads the latest release, installs to `/Applications`, and launches the app.

> On first launch, macOS may ask you to confirm opening the app (System Settings → Privacy & Security → Open Anyway).

## Permissions

ZenSpace will ask for the following permissions on first use:

| Permission | Why |
|-----------|-----|
| Calendar | Display your upcoming events |
| Accessibility | Replace system HUDs (optional) |
| Bluetooth | Show connected audio devices |

Grant them via the in-app prompt or System Settings → Privacy & Security.

## Usage

ZenSpace lives in your **menu bar** (brain icon). Click it to open the popup with:

- Your calendar events
- Now Playing controls
- Focus mode status
- Battery level

### Settings

Open Settings via `⌘,` or right-click the menu bar icon → Settings.

**Tabs:**
- **General** — launch at login, hover behavior, haptics, progressive blur
- **Calendar** — enable/disable, hourly chime, time to leave, transport mode
- **Now Playing** — quick peek, hide while source app active
- **Battery** — low battery threshold, sound, hide percentage
- **Focus** — sound on sleep focus
- **License** — activation status (currently unlocked)
- **About** — version info, check for updates

### Updates

ZenSpace checks GitHub Releases for new versions. When an update is available:

1. Go to Settings → About
2. Click "Check Updates"
3. Click "Update Now" — the app downloads, replaces itself, and restarts

## Uninstall

1. Quit ZenSpace (right-click menu bar icon → Quit)
2. Delete `ZenSpace.app` from `/Applications`
3. Optionally remove preferences: `defaults delete com.zenspace.app`

## Languages

- 🇬🇧 English (default)
- 🇵🇱 Polski

Language follows your macOS system setting.

## Development

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for build instructions, architecture, and project structure.

## License

[MIT](LICENSE) © Kamil Popowicz
