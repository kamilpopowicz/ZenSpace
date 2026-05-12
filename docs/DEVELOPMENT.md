# Development Guide

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

## Architecture

- **MVVM + Clean Architecture**
- **Swift 5.10+**, SwiftUI, SPM
- **macOS 13.0+** (MenuBarExtra requirement)

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/build-app.sh` | Build `.app` bundle from SPM binary |
| `scripts/release.sh <version>` | Tag + build + upload to GitHub Releases |
| `scripts/notarize.sh` | Notarization (placeholder, inactive) |

## Docs

| File | Content |
|------|---------|
| `docs/PRD.md` | Product Requirements |
| `docs/SDD.md` | Software Design |
| `docs/TECH_STACK.md` | Technology stack |
| `docs/ROADMAP.md` | Milestones |
| `docs/QA_CHECKLIST.md` | QA test checklist |
