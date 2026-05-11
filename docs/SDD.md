# SDD (Software Design Document) - ZenSpace

## 2.1. Architektura systemu
Architektura oparta na warstwach:
1. **SwiftUI Views Layer**: Login, Vortex, Settings, Calendar, Media, Focus.
2. **View Models Layer**: LicenseVM, CalendarVM, MediaVM.
3. **View Helpers**: GlassEffect, BlurView, NotchView.
4. **Services Layer**: LicenseSvc, CalendarSvc, MediaSvc, FocusSvc, BatterySvc, DisplaySvc.
5. **XPC Services Layer**: AlcoveHelper.xpc (NowPlaying, BetterDisplay, Audio).

## 2.2. Diagram pakietów
`com.alcove.clone`
- **App**: `AlcoveApp.swift`
- **Core**: Models, Services, Data, Utilities
- **UI**: Login, Main, Settings, Components, Permissions
- **XPC**: Helper
- **Resources**: Assets, Strings

## 2.3. Model danych

### 2.3.1. License Model
`License` i `LicenseStatus` (Codable, Keychain storage).

### 2.3.2. Event Model
`CalendarEvent` (id, title, location, dates, color).

### 2.3.3. FocusMode Model
`FocusMode` enum (10 modes) + `FocusModeSettings`.

### 2.3.4. Media Model
`MediaMetadata` + `PlaybackState`.

### 2.3.5. NotificationSettings Model
Battery, Calendar, Lock Screen, Media, Focus settings.

## 2.4. Services Contract
- `LicenseService`: check status, activate, deactivate.
- `CalendarService`: fetch today/tomorrow events, permissions.
- `MediaService`: metadata, play/pause, controls, observation.
- `FocusService`: current mode, set mode, system monitoring.
- `BatteryService`: level, low battery detection, settings.
- `DisplayService`: active display, BetterDisplay interaction.

## 2.5. Style Guide
- **Naming**: Classes: PascalCase, Properties/Methods: camelCase, Constants: UPPER_SNAKE_CASE.
- **UI Style**: primary/secondary colors, standard macOS typography, spacing (8, 16, 24, 32).
