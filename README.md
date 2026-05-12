# ZenSpace

Personal focus & notification manager for macOS. Lives in your menu bar, integrates with your notch.

## Features

- **Calendar** — upcoming events from EventKit (today/tomorrow)
- **Now Playing** — media controls, artwork, metadata via MediaRemote
- **Focus Modes** — system DND detection with status indicator
- **Battery** — level monitoring, low battery alerts with sound
- **BetterDisplay** — detection, launch/terminate observation, OSD
- **Lock Screen Sounds** — audio feedback on lock/unlock
- **Auto-update** — checks GitHub Releases, downloads and installs in-place

## Requirements

- macOS 13.0+
- Swift 5.10+

## Build

```bash
swift build
swift run
```

## Release

```bash
./scripts/release.sh 1.0.0
```

Builds `.app` bundle, tags, and uploads to GitHub Releases.

## Test

```bash
swift test
```

38 unit tests covering models, services, and ViewModels.

## Project Structure

```
Sources/ZenSpace/
├── App/            — @main entry point (MenuBarExtra)
├── Core/
│   ├── Models/     — License, CalendarEvent, FocusMode, Media, Settings
│   ├── Services/   — Calendar, Media, Focus, Battery, Display, Sound, Update
│   └── Data/       — LicenseRepository (Keychain)
├── UI/
│   ├── Main/       — ContentView, CalendarView, NowPlayingView, FocusView, BatteryView
│   ├── Login/      — LicenseView, LoginView, LicenseViewModel
│   ├── Settings/   — SettingsView (7 tabs)
│   ├── Components/ — GlassEffect, ProgressiveBlur, NotchView
│   └── Permissions/— PermissionsView
├── XPC/            — Protocol + ConnectionManager
└── Resources/      — en.lproj, pl.lproj, Assets
```

## License

See [LICENSE](LICENSE).
