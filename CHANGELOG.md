# Changelog

All notable changes to ZenSpace will be documented in this file.

## [Unreleased]

### Added
- Menu bar app with SwiftUI MenuBarExtra (M1)
- Core data models: License, CalendarEvent, FocusMode, MediaMetadata, NotificationSettings (M2)
- License system with Keychain storage — bypassed, ready to activate (M3)
- Calendar integration via EventKit — today/tomorrow events, permissions, colored indicators (M4)
- Now Playing via MediaRemote — play/pause/next/prev, artwork, metadata (M5)
- Focus Modes — DND detection with polling, status indicator (M6)
- Battery monitoring via IOKit — level, charging, low battery alerts with sound (M7)
- Lock Screen sounds — lock/unlock via DistributedNotificationCenter (M7)
- BetterDisplay integration — detection, launch/terminate observation, OSD (M8)
- UI components: GlassEffect, ProgressiveBlur, NotchView with animations (M9)
- Settings window with 7 tabs (General, Calendar, NowPlaying, Battery, Focus, License, About) (M10)
- Permissions view — Calendar, Accessibility, Bluetooth status checks (M10)
- XPC protocol + connection manager with auto-reconnect (M11)
- 38 unit tests — models, services, ViewModels (M12)
- Notarization placeholder — entitlements, Info.plist, script (M13)
- QA checklist + automated smoke test + localization validation (M14)
- Auto-update from GitHub Releases — check, download, replace, restart (M15)
- Polish localization (264 keys)
- Release scripts (build-app.sh, release.sh)
