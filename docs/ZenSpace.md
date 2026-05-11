• # 📘 KOMPLEKSOWY DOKUMENT TECHNICZNY: BUDOWA APLIKACJI NA BAZIE ALCOVE

  ## 📁 Struktura dokumentacji

  /Users/6824/PrivGit/ALCOVE2/
  ├── PRD.md          (Product Requirements Document)
  ├── SDD.md          (Software Design Document)
  ├── ROADMAP.md      (Roadmap prac)
  └── INSTRUCTIONS.md (Instrukcje dla modelu LLM)

  ———

  ## 📘 1. PRD (Product Requirements Document)

  ### 1.1. Tytuł projektu

  Alcove Clone - Personal Focus & Notification Manager for macOS

  ### 1.2. Dokumentacja wersji

  - Wersja: 1.0
  - Data: 2026-05-08
  - Status: Wersja robocza
  - Autor: Zespół developmentowy

  ### 1.3. Abstrakt

  Aplikacja macOS typu "focus manager" i "notification hub" inspirowana Alcove, z pełnym systemem licencji,
  integracją z BetterDisplay, kalendarzem i systemem powiadomień.

  ### 1.4. Cel projektu

  1. Stworzenie aplikacji macOS do zarządzania koncentracją
  2. Implementacja pełnego systemu licencji (Trial + Pro)
  3. Integracja z BetterDisplay i systemem powiadomień
  4. Monitoring muzyki w trakcie odtwarzania
  5. System focus modes

  ### 1.5. Użytkownik docelowy

  - Osoby pracujące samodzielnie (freelancerzy, developers, designers)
  - Użytkownicy którzy potrzebują zarządzania koncentracją
  - Osoby używające BetterDisplay
  - Użytkownicy którzy chcą kontrolować powiadomienia

  ### 1.6. Niektóre wymagania funkcjonalne

  #### 1.6.1. Licencjonowanie

  - ✅ Trial period: 72 hours
  - ✅ Full activation via license key
  - ✅ Limit 3 devices
  - ✅ License recovery via web
  - ✅ Device management

  #### 1.6.2. Kalendarz

  - ✅ Display events (Today, Tomorrow)
  - ✅ Event notifications
  - ✅ TimeToLeave notifications
  - ✅ Calendar permissions
  - ✅ Chime (hourly sound)
  - ✅ Sound on event
  - ✅ Disable activity during events
  - ✅ Transport mode (Driving, Transit, Walking)
  - ✅ Weather on empty day
  - ✅ Colored indicators

  #### 1.6.3. Media/Now Playing

  - ✅ Play/Pause/Next/Previous controls
  - ✅ PlaybackSpeed control
  - ✅ Display metadata (title, artist, album)
  - ✅ Copy link
  - ✅ Quick Peek

  #### 1.6.4. Focus Modes

  - ✅ 10 focus modes:
      - Do Not Disturb
      - Driving
      - Fitness
      - Gaming
      - Mindfulness
      - Personal
      - Reading
      - Sleep
      - Work
      - Reduce Interruptions

  #### 1.6.5. Bateria

  - ✅ Low battery notifications
  - ✅ Low power mode notifications
  - ✅ Low battery threshold setting
  - ✅ Warn on low battery
  - ✅ Play sound on low battery
  - ✅ Hide percentage

  #### 1.6.6. BetterDisplay Integration

  - ✅ BetterDisplay detection
  - ✅ BetterDisplay launching
  - ✅ BetterDisplay notifications (launched, terminated, OSD)
  - ✅ BetterDisplay requests
  - ✅ Active display detection

  #### 1.6.7. Lock Screen Sounds

  - ✅ Sound on lock
  - ✅ Sound on unlock
  - ✅ Sound on low battery
  - ✅ Sound on sleep focus
  - ✅ Sound on time to leave

  #### 1.6.8. System Integration

  - ✅ BluetoothManager
  - ✅ NowPlaying observation
  - ✅ Calendar permissions
  - ✅ Music permissions
  - ✅ Display settings

  #### 1.6.9. UI/UX

  - ✅ SwiftUI interface
  - ✅ Minimalistic design
  - ✅ Glass effect
  - ✅ Progressive blur
  - ✅ Quick Peek animations
  - ✅ Expanded view on hover
  - ✅ Notifications in notch
  - ✅ Live activities support

  ### 1.7. Non-functional requirements

  #### 1.7.1. Wymagania wydajnościowe

  - Start aplikacji < 2 sekundy
  - Reakcja na powiadomienia < 500ms
  - Memory usage < 200MB

  #### 1.7.2. Wymagania interoperacyjności

  - macOS 12.0+ compatibility
  - Universal binary (x86_64 + arm64)
  - Integration with native APIs (Calendar, Music, BetterDisplay)

  #### 1.7.3. Wymagania dostępności

  - VoiceOver support
  - Dynamic type support
  - High contrast mode

  ### 1.8. Requirements traceability

  | Wymaganie | Status | Opis |
  |-----------|--------|------|
  | FR-01 | ✅ | Licencjonowanie |
  | FR-02 | ✅ | Kalendarz |
  | FR-03 | ✅ | Media/Now Playing |
  | FR-04 | ✅ | Focus Modes |
  | FR-05 | ✅ | Bateria |
  | FR-06 | ✅ | BetterDisplay |
  | FR-07 | ✅ | Lock Screen Sounds |
  | FR-08 | ✅ | System Integration |
  | NFR-01 | ✅ | Wydajność |
  | NFR-02 | ✅ | Interoperacyjność |
  | NFR-03 | ✅ | Dostępność |

  ### 1.9. Risks and constraints

  Ryzyka:

  - 🟡 Nieznane problemy z reverse engineeringem kodu SwiftUI
  - 🟡 Zależność od BetterDisplay (trzeba sprawdzić API)
  - 🟡 Zależność od macOS APIs (Calendar, Music)

  Ograniczenia:

  - ⚠️ Wymagany Xcode 14+ do budowania
  - ⚠️ Wymagany Mac z Apple Silicon lub Intel
  - ⚠️ Wymagana notarization dla Apple

  ———

  ## 📗 2. SDD (Software Design Document)

  ### 2.1. Architektura systemu

  ┌─────────────────────────────────────────────────────────┐
  │                     macOS Application                    │
  ├─────────────────────────────────────────────────────────┤
  │                                                          │
  │  ┌────────────────────────────────────────────────────┐ │
  │  │                 SwiftUI Views Layer                 │ │
  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │ │
  │  │  │  Login   │  │  Vortex  │  │ Settings │         │ │
  │  │  └──────────┘  └──────────┘  └──────────┘         │ │
  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │ │
  │  │  │  Calendar│  │  Media   │  │ Focus    │         │ │
  │  │  └──────────┘  └──────────┘  └──────────┘         │ │
  │  └────────────────────────────────────────────────────┘ │
  │                           │                              │
  │  ┌────────────────────────────────────────────────────┐ │
  │  │              View Models Layer                      │ │
  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │ │
  │  │  │LicenseVM │  │ CalendarVM│  │ MediaVM  │         │ │
  │  │  └──────────┘  └──────────┘  └──────────┘         │ │
  │  └────────────────────────────────────────────────────┘ │
  │                           │                              │
  │  ┌────────────────────────────────────────────────────┐ │
  │  │                View Helpers                         │ │
  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │ │
  │  │  │GlassEff  │  │BlurView  │  │NotchView │         │ │
  │  │  └──────────┘  └──────────┘  └──────────┘         │ │
  │  └────────────────────────────────────────────────────┘ │
  │                           │                              │
  │  ┌────────────────────────────────────────────────────┐ │
  │  │              Services Layer                         │ │
  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │ │
  │  │  │LicenseSvc│  │CalendarSvc│  │MediaSvc  │         │ │
  │  │  └──────────┘  └──────────┘  └──────────┘         │ │
  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │ │
  │  │  │FocusSvc  │  │BatterySvc│  │DisplaySvc│         │ │
  │  │  └──────────┘  └──────────┘  └──────────┘         │ │
  │  └────────────────────────────────────────────────────┘ │
  │                           │                              │
  │  ┌────────────────────────────────────────────────────┐ │
  │  │               XPC Services Layer                    │ │
  │  │  ┌──────────────────────────────────────────────┐  │ │
  │  │  │           AlcoveHelper.xpc                    │  │ │
  │  │  │  • NowPlaying observation                     │  │ │
  │  │  │  • BetterDisplay integration                  │  │ │
  │  │  │  • Audio rendering                            │  │ │
  │  │  └──────────────────────────────────────────────┘  │ │
  │  └────────────────────────────────────────────────────┘ │
  │                                                          │
  └─────────────────────────────────────────────────────────┘

  ### 2.2. Diagram pakietów (Package Diagram)

  com.alcove.clone
  ├── App
  │   └── AlcoveApp.swift
  ├── Core
  │   ├── Models
  │   │   ├── License.swift
  │   │   ├── Event.swift
  │   │   ├── FocusMode.swift
  │   │   └── NotificationSound.swift
  │   ├── Services
  │   │   ├── LicenseService.swift
  │   │   ├── CalendarService.swift
  │   │   ├── MediaService.swift
  │   │   ├── FocusService.swift
  │   │   ├── BatteryService.swift
  │   │   └── DisplayService.swift
  │   ├── Data
  │   │   ├── LicenseRepository.swift
  │   │   └── SettingsRepository.swift
  │   └── Utilities
  │       ├── Constants.swift
  │       ├── Extensions.swift
  │       └── Helpers.swift
  ├── UI
  │   ├── Login
  │   │   ├── LoginView.swift
  │   │   └── LicenseView.swift
  │   ├── Main
  │   │   ├── VortexView.swift
  │   │   ├── NotchView.swift
  │   │   └── NotchNotificationsView.swift
  │   ├── Settings
  │   │   ├── SettingsWindow.swift
  │   │   ├── LicenseSettingsView.swift
  │   │   ├── CalendarSettingsView.swift
  │   │   ├── MediaSettingsView.swift
  │   │   ├── FocusSettingsView.swift
  │   │   └── ...
  │   ├── Components
  │   │   ├── GlassEffectView.swift
  │   │   ├── ProgressiveBlurView.swift
  │   │   └── QuickPeekView.swift
  │   └── Permissions
  │       ├── CalendarPermissionView.swift
  │       └── MusicPermissionView.swift
  ├── XPC
  │   └── Helper
  │       ├── AlcoveHelperService.swift
  │       └── DataModels.swift
  └── Resources
      ├── Assets.xcassets
      └── Localizable.strings

  ### 2.3. Model danych (Data Model)

  #### 2.3.1. License Model

  struct License: Codable {
      let licenseKey: String
      let deviceId: String
      let deviceName: String?
      let createdAt: Date
      let expiryDate: Date?
      let maxDevices: Int
      let activeDevices: Int
  }

  struct LicenseStatus: Codable {
      let isLicensed: Bool
      let isTrial: Bool
      let trialRemainingHours: Int
      let activeDevices: Int
      let maxDevices: Int
      let activationURL: URL?
      let recoveryURL: URL?
  }

  #### 2.3.2. Event Model

  struct CalendarEvent: Codable {
      let id: String
      let title: String
      let location: String?
      let startDate: Date
      let endDate: Date
      let isAllDay: Bool
      let calendarColor: String?
      let isTomorrow: Bool
      let isPast: Bool
      let isUpcoming: Bool
  }

  struct EventSection {
      let title: String
      let events: [CalendarEvent]
      let isEmpty: Bool
  }

  #### 2.3.3. FocusMode Model

  enum FocusMode: String, CaseIterable, Codable {
      case doNotDisturb
      case driving
      case fitness
      case gaming
      case mindfulness
      case personal
      case reading
      case sleep
      case work
      case reduceInterruptions
  }

  struct FocusModeSettings: Codable {
      let mode: FocusMode
      let isEnabled: Bool
      let autoActivate: Bool
      let soundEnabled: Bool
      let disableNotifications: Bool
      let disableDND: Bool
  }

  #### 2.3.4. Media Model

  struct MediaMetadata: Codable {
      let title: String
      let artist: String?
      let album: String?
      let albumArtwork: Data?
      let playbackState: PlaybackState
      let playbackPosition: TimeInterval
      let playbackSpeed: Float
      let isDolbyAtmos: Bool
  }

  enum PlaybackState: String, Codable {
      case playing
      case paused
      case stopped
      case buffering
  }

  #### 2.3.5. NotificationSettings Model

  struct NotificationSettings: Codable {
      // Battery
      let lowBatteryEnabled: Bool
      let lowBatteryThreshold: Int
      let lowPowerModeEnabled: Bool
      let lowPowerSoundEnabled: Bool
      let hideBatteryPercentage: Bool

      // Calendar
      let calendarEnabled: Bool
      let calendarPermissions: [String]
      let chimeEnabled: Bool
      let soundOnEventEnabled: Bool
      let soundOnNotificationEnabled: Bool
      let disableActivityDuringEvents: Bool
      let timeToLeaveEnabled: Bool
      let transportMode: TransportMode
      let showWeatherOnEmptyDay: Bool
      let timeBeforeEvent: Int

      // Lock Screen
      let soundOnLock: Bool
      let soundOnUnlock: Bool
      let soundOnSleepFocus: Bool
      let soundOnTimeToLeave: Bool

      // Media
      let nowPlayingEnabled: Bool
      let quickPeekEnabled: Bool

      // Focus
      let focusSoundEnabled: Bool
  }

  #### 2.3.6. DisplaySettings Model

  struct DisplaySettings: Codable {
      let displayType: DisplayType
      let betterDisplayIntegration: Bool
      let betterDisplayLaunched: Bool
      let betterDisplayTerminated: Bool
      let betterDisplayOSD: Bool
      let betterDisplayRequest: Bool

      enum DisplayType: String, Codable {
          case activeDisplay
          case builtInDisplay
          case mainScreen
      }
  }

  struct BetterDisplayNotificationData: Codable {
      let title: String
      let message: String
      let type: NotificationType
  }

  enum NotificationType: String, Codable {
      case launched
      case terminated
      case osd
      case request
  }

  ### 2.4. Diagram klas (Class Diagram)

  ┌────────────────────────────────────────────────────────────┐
  │                      LicenseService                        │
  ├────────────────────────────────────────────────────────────┤
  │ + checkLicenseStatus() -> LicenseStatus                    │
  │ + activateLicense(key: String, device: Device) -> Bool     │
  │ + deactivateLicense() -> Bool                             │
  │ + getActiveDevices() -> [Device]                           │
  │ + canAddDevice() -> Bool                                  │
  │ + saveLicense(_:) -> Bool                                  │
  │ + loadLicense() -> License?                                │
  │ - generateDeviceID() -> String                            │
  └────────────────────────────────────────────────────────────┘
                             ▲
                             │
  ┌────────────────────────────────────────────────────────────┐
  │                      LicenseRepository                      │
  ├────────────────────────────────────────────────────────────┤
  │ + saveLicense(_:) -> Bool                                 │
  │ + loadLicense() -> License?                               │
  │ + removeLicense() -> Bool                                 │
  │ - saveToDefaults(_:)                                      │
  │ - loadFromDefaults() -> License?                          │
  └────────────────────────────────────────────────────────────┘

  ┌────────────────────────────────────────────────────────────┐
  │                    CalendarService                         │
  ├────────────────────────────────────────────────────────────┤
  │ + getTodayEvents() -> [CalendarEvent]                      │
  │ + getTomorrowEvents() -> [CalendarEvent]                   │
  │ + getEvent(at: Date) -> CalendarEvent?                     │
  │ + subscribeToEvents() -> Cancellable                       │
  │ + unsubscribeFromEvents()                                 │
  │ + getPermissions() -> [String]                             │
  │ - fetchCalendarEvents()                                    │
  └────────────────────────────────────────────────────────────┘
                             ▲
                             │
  ┌────────────────────────────────────────────────────────────┐
  │                    MediaService                           │
  ├────────────────────────────────────────────────────────────┤
  │ + getCurrentMetadata() -> MediaMetadata?                   │
  │ + isPlaying() -> Bool                                     │
  │ + playPause()                                             │
  │ + next()                                                   │
  │ + previous()                                               │
  │ + setPlaybackSpeed(_:)                                    │
  │ + copyLink() -> URL?                                      │
  │ + enableNowPlayingObservation()                           │
  │ - observeNowPlaying()                                     │
  └────────────────────────────────────────────────────────────┘
                             ▲
                             │
  ┌────────────────────────────────────────────────────────────┐
  │                    FocusService                           │
  ├────────────────────────────────────────────────────────────┤
  │ + getCurrentFocusMode() -> FocusMode?                     │
  │ + setFocusMode(_:) -> Bool                                │
  │ + isModeEnabled(_:) -> Bool                               │
  │ + toggleMode(_:)                                          │
  │ + getFocusModeSettings(_:) -> FocusModeSettings            │
  │ - monitorSystemFocus()                                    │
  └────────────────────────────────────────────────────────────┘
                             ▲
                             │
  ┌────────────────────────────────────────────────────────────┐
  │                    BatteryService                         │
  ├────────────────────────────────────────────────────────────┤
  │ + getBatteryLevel() -> Int                                │
  │ + isLowBattery() -> Bool                                  │
  │ + isLowPowerMode() -> Bool                                │
  │ + getSettings() -> BatterySettings                        │
  │ - monitorBattery()                                        │
  └────────────────────────────────────────────────────────────┘
                             ▲
                             │
  ┌────────────────────────────────────────────────────────────┐
  │                    DisplayService                         │
  ├────────────────────────────────────────────────────────────┤
  │ + getActiveDisplay() -> String                            │
  │ + getMainDisplay() -> String                              │
  │ + getDisplays() -> [String]                               │
  │ + isBetterDisplayRunning() -> Bool                        │
  │ + launchBetterDisplay()                                   │
  │ + subscribeToBetterDisplayNotifications() -> Cancellable   │
  │ - subscribeToBetterDisplay()                              │
  └────────────────────────────────────────────────────────────┘

  ### 2.5. Diagram sekwencji (Sequence Diagram) - Example: Calendar Flow

  User       LicenseService    CalendarService   CalendarAPI    CalendarUI
   │            │                 │                 │              │
   │─── Activate License ────────►│                 │              │
   │            │                 │                 │              │
   │            │<─── Success ────│                 │              │
   │            │                 │                 │              │
   │            │◄───────────────│                 │              │
   │            │                 │                 │              │
   │─── Request Today Events ────►│                 │              │
   │            │                 │                 │              │
   │            │                 │─── Get Events ──►│              │
   │            │                 │◄────────────────│              │
   │            │                 │                 │              │
   │            │◄───────────────│                 │              │
   │            │                 │                 │              │
   │─── Update CalendarView ◄─────│                 │              │

  ### 2.6. Diagram stanów (State Diagram) - License

  ┌──────────┐
  │ Unset    │
  └────┬─────┘
       │ activateLicense()
       ▼
  ┌──────────┐
  │  Active  │─────────┐
  └────┬─────┘         │
       │ trialExpired  │
       ▼                │
  ┌──────────┐          │
  │  Trial   │          │
  └────┬─────┘          │
       │ 72h elapsed    │
       ▼                │
  ┌──────────┐          │
  │ Expired  │◄─────────┘
  └──────────┘
       │ activateLicense()
       ▼
  ┌──────────┐
  │  Active  │ (Pro)
  └──────────┘

  ### 2.7. Diagram architektury UI

  ┌─────────────────────────────────────────┐
  │          AppCoordinator                  │
  │  - manages navigation                    │
  │  - coordinates views                     │
  └────────────┬────────────────────────────┘
               │
      ┌────────┴────────┬────────────────┬────────────┐
      │                 │                │            │
  ┌───▼────┐      ┌────▼─────┐     ┌────▼─────┐  ┌────▼────┐
  │ Login  │      │  Vortex  │     │ Settings │  │  About  │
  │ View   │      │  View    │     │  Window  │  │  View   │
  └────────┘      └────┬─────┘     └──────────┘  └────────┘
                       │
                ┌──────┴──────┬──────────┬──────────┐
                │             │          │          │
          ┌────▼─────┐  ┌────▼─────┐ ┌────▼─────┐ ┌────▼─────┐
          │Calendar  │  │  Media   │ │ Focus    │ │ Battery  │
          │Settings  │  │ Settings │ │ Settings │ │ Settings │
          └──────────┘  └──────────┘ └──────────┘ └──────────┘

  ### 2.8. Diagram relacji (ERD) - Database

  ┌──────────────┐
  │  License     │
  ├──────────────┤
  │ PK: licenseKey│
  │ PK: deviceId  │
  │ deviceName   │
  │ createdAt    │
  │ expiryDate   │
  │ maxDevices   │
  │ activeDevices│
  └──────────────┘

  ┌──────────────────┐
  │   Settings       │
  ├──────────────────┤
  │ PK: key          │
  │ value (JSON)     │
  │ lastModified     │
  └──────────────────┘

  ┌─────────────────┐
  │ CalendarEvents  │
  ├─────────────────┤
  │ PK: id          │
  │ title           │
  │ startDate       │
  │ endDate         │
  │ isAllDay        │
  │ calendarColor   │
  └─────────────────┘

  ### 2.9. API Contract (BetterDisplay)

  // BetterDisplay XPC Service (example)
  protocol BetterDisplayXPCService: class {
      func isRunning() async -> Bool
      func launch() async throws
      func terminate() async throws
  }

  struct BetterDisplayNotificationData {
      let title: String
      let message: String
      let type: NotificationType
  }

  enum NotificationType {
      case launched
      case terminated
      case osd
      case request
      case betterDisplayRequest
  }

  ### 2.10. Style Guide

  #### 2.10.1. Naming Conventions

  // Classes: PascalCase
  class LicenseService: NSObject { }

  // Properties: camelCase
  let licenseKey: String

  // Methods: camelCase
  func checkLicenseStatus()

  // Constants: UPPER_SNAKE_CASE
  let MAX_DEVICES = 3
  let TRIAL_DURATION_HOURS = 72

  #### 2.10.2. UI Style

  // Colors
  let primaryColor = Color(hex: "#007AFF")
  let secondaryColor = Color(hex: "#5856D6")
  let background = Color(NSColor.controlBackgroundColor)
  let foreground = Color(NSColor.controlTextColor)

  // Typography
  Font.largeTitle = .systemFont(ofSize: 32, weight: .bold)
  Font.title = .systemFont(ofSize: 22, weight: .semibold)
  Font.body = .systemFont(ofSize: 15, weight: .regular)
  Font.callout = .systemFont(ofSize: 13, weight: .regular)

  // Spacing
  let spacingSmall: CGFloat = 8
  let spacingMedium: CGFloat = 16
  let spacingLarge: CGFloat = 24
  let spacingXL: CGFloat = 32

  ———

  ## 📊 3. ROADMAP (Harmonogram prac)

  ### 3.1. Wizja projektu

  Short-term (1-2 tygodnie)

  - ✅ Reverse engineering Alcove.app
  - ✅ Documentacja funkcjonalności
  - ✅ Tworzenie struktur projektu
  - ✅ Stworzenie podstawowej aplikacji

  Mid-term (2-4 tygodnie)

  - 🟡 Implementacja licencji
  - 🟡 Implementacja kalendarza
  - 🟡 Implementacja Media/Now Playing
  - 🟡 Implementacja Focus Modes

  Long-term (4-8 tygodni)

  - 🟡 BetterDisplay integration
  - 🟡 Battery notifications
  - 🟡 Lock screen sounds
  - 🟡 Polish i optymalizacja
  - 🟡 Notarization i release

  ### 3.2. Zadania i milestones

  #### 🎯 Milestone 1: Setup (Dni 1-2)

  Cel: Dobra struktura projektu, środowisko Xcode

  - [ ] 1.1 Stworzenie folderu projektu
  - [ ] 1.2 Konfiguracja Xcode project
  - [ ] 1.3 Dodanie target: macOS App
  - [ ] 1.4 Konfiguracja schemes (Debug, Release)
  - [ ] 1.5 Dodanie Swift Package dependencies (jeśli potrzebne)
  - [ ] 1.6 Tworzenie folderów struktur projektu
  - [ ] 1.7 Stworzenie głównego App entry point
  - [ ] 1.8 Dodanie podstawowych Resources (Assets, Localizable.strings)
  - [ ] 1.9 Konfiguracja entitlements
  - [ ] 1.10 Test podstawowej aplikacji (Empty UI)

  Deliverable: Działająca aplikacja z pustym UI

  #### 🎯 Milestone 2: Core Data Models (Dni 3-4)

  Cel: System licencji i dane podstawowe

  - [ ] 2.1 Stworzenie modelu License
  - [ ] 2.2 Stworzenie modelu LicenseStatus
  - [ ] 2.3 Stworzenie modelu CalendarEvent
  - [ ] 2.4 Stworzenie modelu FocusMode
  - [ ] 2.5 Stworzenie modelu MediaMetadata
  - [ ] 2.6 Stworzenie modelu NotificationSettings
  - [ ] 2.7 Stworzenie modelu DisplaySettings
  - [ ] 2.8 Implementacja LicenseRepository
  - [ ] 2.9 Implementacja SettingsRepository
  - [ ] 2.10 Dodanie UserDefaults integration
  - [ ] 2.11 Tworzenie Constants.swift
  - [ ] 2.12 Testowanie modeli danych
  - [ ] 2.13 Dodanie testów jednostkowych

  Deliverable: Pełny system modeli danych

  #### 🎯 Milestone 3: License System (Dni 5-7)

  Cel: System licencji działający

  - [ ] 3.1 Implementacja LicenseService
  - [ ] 3.2 Device ID generation
  - [ ] 3.3 License status checking
  - [ ] 3.4 Activation flow
  - [ ] 3.5 Trial management (72h timer)
  - [ ] 3.6 Device management (3 device limit)
  - [ ] 3.7 License recovery URL handling
  - [ ] 3.8 Implementacja LicenseView
  - [ ] 3.9 Implementacja LicenseSettingsView
  - [ ] 3.10 Navigation to BrowserView for recovery
  - [ ] 3.11 Validation logic (license key format)
  - [ ] 3.12 Error handling
  - [ ] 3.13 UI polish (activation form, status display)
  - [ ] 3.14 Testy systemu licencji
  - [ ] 3.15 Edge cases (expired trial, invalid key)

  Deliverable: Działający system licencji z UI

  #### 🎯 Milestone 4: Calendar Integration (Dni 8-10)

  Cel: Kalendarz z wydarzeniami

  - [ ] 4.1 Implementacja CalendarService
  - [ ] 4.2 Calendar permissions request
  - [ ] 4.3 Fetch today events
  - [ ] 4.4 Fetch tomorrow events
  - [ ] 4.5 Calendar subscription (notifications)
  - [ ] 4.6 Event parsing (startDate, endDate, location)
  - [ ] 4.7 Event grouping (Today, Tomorrow, Empty)
  - [ ] 4.8 Colored indicators based on calendar color
  - [ ] 4.9 Implementacja CalendarView
  - [ ] 4.10 Implementacja CalendarSettingsView
  - [ ] 4.11 Calendar permission view
  - [ ] 4.12 Settings: enable/disable calendar
  - [ ] 4.13 Settings: time before event
  - [ ] 4.14 Settings: disable activity during events
  - [ ] 4.15 Settings: transport mode
  - [ ] 4.16 Settings: show weather on empty day
  - [ ] 4.17 Testy integracji kalendarza
  - [ ] 4.18 Obsługa błędów (brak uprawnień)

  Deliverable: Kalendarz z pełnym UI

  #### 🎯 Milestone 5: Media/Now Playing (Dni 11-12)

  Cel: Kontrola muzyki

  - [ ] 5.1 Implementacja MediaService
  - [ ] 5.2 NowPlaying observation setup
  - [ ] 5.3 Media metadata extraction (title, artist, album)
  - [ ] 5.4 Playback state monitoring (playing, paused)
  - [ ] 5.5 Playback speed control
  - [ ] 5.6 Play/Pause/Next/Previous controls
  - [ ] 5.7 Album artwork retrieval
  - [ ] 5.8 Copy link functionality
  - [ ] 5.9 Implementacja MusicView
  - [ ] 5.10 Implementacja NowPlayingSettingsView
  - [ ] 5.11 Quick Peek animation
  - [ ] 5.12 Testy kontrolera muzyki
  - [ ] 5.13 Edge cases (no media playing)

  Deliverable: Działający controler muzyki

  #### 🎯 Milestone 6: Focus Modes (Dni 13-14)

  Cel: System focus modes

  - [ ] 6.1 Stworzenie enum FocusMode
  - [ ] 6.2 Implementacja FocusService
  - [ ] 6.3 Focus mode settings management
  - [ ] 6.4 System focus monitoring
  - [ ] 6.5 Auto-activation on mode change
  - [ ] 6.6 Toggle per mode
  - [ ] 6.7 Enable/disable notifications per mode
  - [ ] 6.8 Sound per mode
  - [ ] 6.9 Reduce interruptions per mode
  - [ ] 6.10 Implementacja FocusSettingsView
  - [ ] 6.11 Settings UI for each mode
  - [ ] 6.12 Quick activation (Cmd+1-10)
  - [ ] 6.13 Testy focus modes
  - [ ] 6.14 Integration z systemem DND

  Deliverable: Działający system focus modes

  #### 🎯 Milestone 7: Battery & Lock Screen (Dni 15-16)

  Cel: Monitoring baterii i dźwięki

  - [ ] 7.1 Implementacja BatteryService
  - [ ] 7.2 Battery level monitoring
  - [ ] 7.3 Low battery detection
  - [ ] 7.4 Low power mode detection
  - [ ] 7.5 Battery settings UI
  - [ ] 7.6 Low battery threshold setting
  - [ ] 7.7 Hide battery percentage toggle
  - [ ] 7.8 Sound on low battery
  - [ ] 7.9 Low power mode notifications
  - [ ] 7.10 Lock screen sound manager
  - [ ] 7.11 Play sound on lock/unlock
  - [ ] 7.12 Play sound on sleep focus
  - [ ] 7.13 Play sound on time to leave
  - [ ] 7.14 Battery icon in notch
  - [ ] 7.15 Testy baterii

  Deliverable: Działający system baterii i lock screen

  #### 🎯 Milestone 8: BetterDisplay Integration (Dni 17-18)

  Cel: Integracja z BetterDisplay

  - [ ] 8.1 Implementacja DisplayService
  - [ ] 8.2 BetterDisplay detection
  - [ ] 8.3 BetterDisplay launching
  - [ ] 8.4 BetterDisplay termination
  - [ ] 8.5 BetterDisplay notifications subscription
  - [ ] 8.6 BetterDisplay OS notification UI
  - [ ] 8.7 BetterDisplay request notification
  - [ ] 8.8 BetterDisplay running state
  - [ ] 8.9 Active display detection
  - [ ] 8.10 BetterDisplay settings integration
  - [ ] 8.11 Display type selection (Active, Built-in, Main)
  - [ ] 8.12 Testy integracji BetterDisplay
  - [ ] 8.13 Fallback dla braku BetterDisplay

  Deliverable: Działająca integracja BetterDisplay

  #### 🎯 Milestone 9: UI Polish & UX (Dni 19-21)

  Cel: Poprawa UI i UX

  - [ ] 9.1 GlassEffectView implementation
  - [ ] 9.2 ProgressiveBlurView implementation
  - [ ] 9.3 NotchView implementation
  - [ ] 9.4 QuickPeek animation
  - [ ] 9.5 Expanded view on hover
  - [ ] 9.6 Color scheme (Primary, Secondary, Background)
  - [ ] 9.7 Typography (Titles, Body, Callouts)
  - [ ] 9.8 Spacing and layout refinement
  - [ ] 9.9 Smooth transitions
  - [ ] 9.10 Accessibility improvements (VoiceOver)
  - [ ] 9.11 Dynamic type support
  - [ ] 9.12 High contrast mode support
  - [ ] 9.13 Icon redesign
  - [ ] 9.14 Testy UI

  Deliverable: Polerowane UI

  #### 🎯 Milestone 10: Settings & Permissions (Dni 22-23)

  Cel: Kompletne okno ustawień

  - [ ] 10.1 Stworzenie SettingsWindow
  - [ ] 10.2 Navigation in Settings
  - [ ] 10.3 General Settings tab
  - [ ] 10.4 Calendar Settings tab
  - [ ] 10.5 Media Settings tab
  - [ ] 10.6 Focus Settings tab
  - [ ] 10.7 Battery Settings tab
  - [ ] 10.8 Display Settings tab
  - [ ] 10.9 Lock Screen Settings tab
  - [ ] 10.10 Accessibility Settings tab
  - [ ] 10.11 About tab
  - [ ] 10.12 Export/Import settings
  - [ ] 10.13 Reset to defaults
  - [ ] 10.14 Testy okna ustawień

  Deliverable: Kompletne okno ustawień

  #### 🎯 Milestone 11: XPC Helper (Dni 24-25)

  Cel: Helper service for audio/betterdisplay

  - [ ] 11.1 Stworzenie XPC target
  - [ ] 11.2 Implementacja AlcoveHelperService
  - [ ] 11.3 NowPlaying observation in XPC
  - [ ] 11.4 Audio rendering (if needed)
  - [ ] 11.5 BetterDisplay XPC communication
  - [ ] 11.6 Permissions handling
  - [ ] 11.7 Error handling in XPC
  - [ ] 11.8 Security (sandboxing)
  - [ ] 11.9 Testy XPC service
  - [ ] 11.10 Memory leaks check

  Deliverable: Działający XPC helper

  #### 🎯 Milestone 12: Notifications & Sounds (Dni 26-27)

  Cel: Kompletne system powiadomień

  - [ ] 12.1 System notification service
  - [ ] 12.2 Custom notification templates
  - [ ] 12.3 Sounds manager (chime, event, low battery)
  - [ ] 12.4 Notification sound selection
  - [ ] 12.5 Sound on calendar event
  - [ ] 12.6 Sound on notification
  - [ ] 12.7 Sound on low battery
  - [ ] 12.8 Sound on time to leave
  - [ ] 12.9 Notification permissions
  - [ ] 12.10 Testy powiadomień

  Deliverable: Działający system powiadomień

  #### 🎯 Milestone 13: About, Update, Permissions (Dni 28-29)

  Cel: Dodatkowe ekrany i uprawnienia

  - [ ] 13.1 Implementacja AboutView
  - [ ] 13.2 Version display
  - [ ] 13.3 Changelog display
  - [ ] 13.4 Update notification view
  - [ ] 13.5 BrowserView for recovery license
  - [ ] 13.6 Calendar permission view
  - [ ] 13.7 Music permission view
  - [ ] 13.8 Handle permission denials
  - [ ] 13.9 Request on first launch
  - [ ] 13.10 Testy dodatkowych ekranów

  Deliverable: Kompletne ekranu powitalne

  #### 🎯 Milestone 14: Testing & QA (Dni 30-31)

  Cel: Sprawdzenie jakości

  - [ ] 14.1 Testy jednostkowe (unit tests)
  - [ ] 14.2 Testy integracyjne (integration tests)
  - [ ] 14.3 Testy UI (UI tests)
  - [ ] 14.4 Testy systemu licencji
  - [ ] 14.5 Testy baterii
  - [ ] 14.6 Testy kalendarza
  - [ ] 14.7 Testy mediów
  - [ ] 14.8 Testy focus modes
  - [ ] 14.9 Testy notyfikacji
  - [ ] 14.10 Performance testing
  - [ ] 14.11 Memory leak check
  - [ ] 14.12 Crash reporting

  Deliverable: Raport testów QA

  #### 🎯 Milestone 15: Release (Dni 32-33)

  Cel: Notarization i release

  - [ ] 15.1 Clean build (Release scheme)
  - [ ] 15.2 Notarization request
  - [ ] 15.3 Notarization verification
  - [ ] 15.4 Stapling notarization ticket
  - [ ] 15.5 Ad-hoc signing (zdebug)
  - [ ] 15.6 Code signing configuration
  - [ ] 15.7 Creating .dmg
  - [ ] 15.8 Creating .pkg installer
  - [ ] 15.9 App Store submission (optional)
  - [ ] 15.10 Release notes
  - [ ] 15.11 Changelog creation
  - [ ] 15.12 Version bump (2.0.0)

  Deliverable: Gotowy do dystrybucji .app

  ### 3.3. Burndown chart (estymacja)

  | Tydzień | Zadania | Est. Czas |
  |---------|---------|-----------|
  | W1 | Setup, Models | 3 dni |
  | W2 | License System | 3 dni |
  | W3 | Calendar, Media | 3 dni |
  | W4 | Focus, Battery | 3 dni |
  | W5 | BetterDisplay | 2 dni |
  | W6 | UI Polish | 3 dni |
  | W7 | Settings, Permissions | 3 dni |
  | W8 | XPC, Notifications | 3 dni |
  | W9 | Final Polish, Testing | 4 dni |
  | W10 | Release | 3 dni |
  | SUMA | | 27 dni (≈4 tygodnie) |

  ### 3.4. Wskaźniki postępu (KPIs)

  | KPI | Cel | Metryka |
  |-----|-----|---------|
  | Udział kodu Swift | 100% | 15,000+ lines |
  | Testy jednostkowe | >80% | >12 testów |
  | Zasięg UI | 100% | Wszystkie widoki |
  | Bug-free build | 100% | 0 build errors |
  | Notarization | 100% | Success |
  | Release size | <50MB | 25MB |

  ———

  ## 🤖 4. INSTRUKCJE DLA MODELU LLM (LLM INSTRUCTIONS)

  ### 4.1. Cel zadania

  Stworzyć pełną implementację aplikacji Alcove Clone na macOS (SwiftUI) z systemem licencji, integracją z
  kalendarzem, mediami, focus modes i BetterDisplay.

  ### 4.2. Context i background

  - Aplikacja Alcove.app została przeanalizowana i zrozumiana
  - Wszystkie funkcjonalności zostały zmapowane
  - Aplikacja jest napisana w SwiftUI
  - System licencji wymaga implementacji od zera
  - Integracje z macOS API (Calendar, Music, System, BetterDisplay) wymagają znajomości natywnych
    interfejsów

  ### 4.3. Persona agenta

  Jesteś zaawansowanym Swift/iOS/macOS developerem z 5+ lat doświadczenia. Masz głęboką wiedzę o:

  - SwiftUI framework
  - macOS development
  - Xcode ecosystem
  - System APIs (Calendar, Music, Focus, Battery)
  - Architecture patterns (MVVM, Clean Architecture)
  - License/activation systems
  - Notarization i code signing

  ### 4.4. Style kodu

  Kompilacja:

  - Użyj Swift 5.10+
  - Xcode 15+
  - macOS 12.0+ support
  - Universal binary (x86_64 + arm64)

  Naming:

  // Classes: PascalCase
  class LicenseService: NSObject { }

  // Properties: camelCase
  let licenseKey: String

  // Methods: camelCase
  func checkLicenseStatus() -> Bool

  // Constants: UPPER_SNAKE_CASE
  let MAX_DEVICES = 3

  Formatowanie:

  - 4 spacje indent
  - Semicolon na końcu instrukcji
  - Brak trailing whitespace
  - Brak komentarzy blokowych na końcu linii

  ### 4.5. Praca z użytkownikiem

  Przyjmowanie zadań:

  1. Potwierdź zrozumienie zadania
  2. Poproś o potwierdzenie startu
  3. Przedział 5-10 linii przed każdą akcją w konsoli
  4. Podsumuj każdy major milestone

  Zarządzanie błędami:

  1. Loguj wszystkie błędy
  2. Sugeruj rozwiązania
  3. Jeśli nie możesz rozwiązać problemu, poproś o pomoc

  Komunikacja:

  - Konkretne, bez zbędnych komentarzy
  - Jasne etykiety kroków
  - Linki do Apple dokumentacji

  ### 4.6. Architektura projektu

  Struktura folderów:

  AlcoveClone/
  ├── AlcoveCloneApp/
  │   ├── AlcoveCloneApp.swift
  │   ├── AppCoordinator.swift
  │   └── AppDelegate.swift
  ├── Core/
  │   ├── Models/
  │   ├── Services/
  │   ├── Data/
  │   └── Utilities/
  ├── UI/
  │   ├── Login/
  │   ├── Main/
  │   ├── Settings/
  │   ├── Components/
  │   └── Permissions/
  ├── XPC/
  │   └── Helper/
  └── Resources/

  MVVM Pattern:

  - Model: Dane (structs, enums)
  - View: SwiftUI Views
  - ViewModel: ObservableObject

  Dependency Injection:

  - Services powinny być singletons lub injected przez Coordinator
  - Użyj @Injected lub @Global singleton

  ### 4.7. Priority i flow pracy

  Kolejność zadań:

  1. Setup projektu (Xcode, targets)
  2. Core Models
  3. License System
  4. Calendar Integration
  5. Media/Now Playing
  6. Focus Modes
  7. Battery & Lock Screen
  8. BetterDisplay Integration
  9. UI Polish
  10. Settings & Permissions
  11. XPC Helper
  12. Notifications
  13. Final Testing
  14. Release

  Praca z Xcode:

  - Użyj open do otwarcia projektu
  - Użyj xcodebuild do kompilacji (debug/release)
  - Testuj na Simulatorze i na realnym urządzeniu

  ### 4.8. Przykładowe komendy

  Setup:

  # Otworzenie projektu
  open AlcoveClone.xcodeproj

  # Kompilacja
  xcodebuild -scheme AlcoveClone -configuration Debug clean build

  # Uruchomienie na Simulatorze
  xcrun simctl boot "iPhone 15 Pro"
  xcrun simctl launch booted com.alcove.clone.AlcoveCloneApp

  Debug:

  # Logi konsola
  log stream --predicate 'processImagePath CONTAINS "AlcoveClone"' --level debug

  # Testy
  xcodebuild test -scheme AlcoveClone -destination 'platform=macOS'

  # Inspekcja
  lldb /Applications/AlcoveClone.app/Contents/MacOS/AlcoveClone

  ### 4.9. Best practices

  Security:

  - Nie przechowuj licencji w plaintext
  - Użyj secure storage (Keychain)
  - Validuj inputy (licencja, URL, itp.)
  - Sanitize strings

  Performance:

  - Obserwuj NowPlaying tylko jeśli potrzebne
  - Cache kalendarzowe events
  - Debounce UI updates
  - Unsubscribe od notifications

  Testing:

  - Unit tests dla Services
  - Integration tests dla integracji
  - UI tests dla main flow

  Documentation:

  - Komentarze do publicznych API
  - Wymagane komentarze (@escaping, @inlinable)
  - Dobra nazewnictwo

  ### 4.10. System licencji szczegóły

  Device ID Generation:

  // UUID + serial number combination
  let serialNumber = sysctlbyname("hw.model")
  let deviceID = "\(UUID()).\(serialNumber)"

  License Validation:

  - Format: XXXX-XXXX-XXXX-XXXX (4 grupy po 4 znaki)
  - Checksum validation (jeśli dostępne)
  - Server-side verification (opcjonalne)

  Trial Management:

  - 72h timer od pierwszego uruchomienia
  - Zapis w UserDefaults
  - Nie-resetable (jako protection)

  ### 4.11. BetterDisplay API

  Dostępne notifications:

  enum BetterDisplayNotificationType: String {
      case launched = "com.henrikruscon.BetterDisplay.Launched"
      case terminated = "com.henrikruscon.BetterDisplay.Terminated"
      case osd = "com.henrikruscon.BetterDisplay.OSDNotification"
      case request = "com.henrikruscon.BetterDisplay.Request"
      case betterDisplayRequest = "com.henrikruscon.BetterDisplay.BetterDisplayRequest"
  }

  Integration:

  // Subscribe to notifications
  NotificationCenter.default.addObserver(
      forName: NSNotification.Name(BetterDisplayNotificationType.osd.rawValue),
      object: nil,
      queue: .main
  ) { notification in
      // Handle OSD notification
  }

  ### 4.12. Calendar API

  Permissions:

  // Request Calendar access
  let authStatus = EKEventStore.authorizationStatus(for: .event)
  if authStatus == .notDetermined {
      EKEventStore.requestAccess(to: .event) { granted, error in
          // Handle result
      }
  }

  Fetch Events:

  let predicate = eventStore.predicateForEvents(
      withStart: startDate,
      end: endDate,
      calendars: calendars
  )
  let events = eventStore.events(matching: predicate)

  ### 4.13. Media API

  NowPlaying:

  MPMusicPlayerController.systemMusicPlayer.play()
  MPMusicPlayerController.systemMusicPlayer.pause()

  MPNowPlayingInfoCenter.default().nowPlayingInfo = [
      MPMediaItemProperty.title: "Track Title",
      MPMediaItemProperty.artist: "Artist Name"
  ]

  ### 4.14. Focus Modes

  System Focus:

  // Monitor system focus changes
  NotificationCenter.default.addObserver(
      forName: NSNotification.Name("NSApplicationDidChangeUserInterfaceStyleNotification"),
      object: nil,
      queue: .main
  ) { _ in
      // Check current focus mode
  }

  ### 4.15. Battery API

  // Battery level
  let batteryLevel = device.batteryLevel // 0.0 - 1.0

  // Low power mode
  let lowPowerMode = device.isLowPowerModeEnabled

  // Battery state
  let batteryState = device.batteryState

  ### 4.16. Lock Screen Sounds

  System Sounds:

  // Lock sound
  NSSound(named: NSSound.Name("Lock"))?.play()

  // Unlock sound
  NSSound(named: NSSound.Name("Unlock"))?.play()

  // Custom sounds (from app bundle)
  if let soundURL = Bundle.main.url(forResource: "chime", withExtension: "caf") {
      NSSound(named: NSSound.Name("Chime"))?.play()
  }

  ### 4.17. Error Handling

  Custom Errors:

  enum AppError: Error {
      case licenseActivationFailed(String)
      case calendarAccessDenied
      case mediaPlaybackFailed
      case betterDisplayNotFound
      case invalidInput(String)
      case networkError(Error)
  }

  Logging:

  func logError(_ error: Error, context: String = #function) {
      NSLog("[\(context)] Error: \(error)")
  }

  ### 4.18. Best practice - Code Review Checklist

  - ✅ Wszystkie view models dziedziczą z ObservableObject
  - ✅ Wszystkie services są singletons lub wstrzykiwane
  - ✅ Brak hardcodowanych wartości (użyj Constants)
  - ✅ Wszystkie pliki mają docstrings
  - ✅ Error handling dla każdego API call
  - ✅ Unit tests dla Services
  - ✅ UI tests dla main flow
  - ✅ Brak memory leaks (weak/unowned)
  - ✅ Code formatting (SwiftLint)
  - ✅ Performance considerations

  ### 4.19. End-to-End Flow Example

  Activation Flow:

  1. User opens app -> LoginWindowContainerView
  2. App checks license -> LicenseService.checkLicenseStatus()
  3. If trial -> LicenseView (show countdown)
  4. If licensed -> VortexView (main UI)
  5. User enters license key -> BrowserView (external)
  6. Key submitted -> Server validation
  7. Success -> License saved to Keychain
  8. Redirect to VortexView

  Calendar Flow:

  1. App starts -> CalendarPermissionView (if needed)
  2. User grants permission
  3. CalendarService.fetchTodayEvents()
  4. Events parsed & formatted
  5. CalendarView displayed in VortexView
  6. User taps event -> Join/Dismiss

  ### 4.20. Testing Strategy

  Unit Tests:

  class LicenseServiceTests: XCTestCase {
      func testLicenseActivation() { }
      func testTrialExpiry() { }
      func testDeviceLimit() { }
  }

  Integration Tests:

  class CalendarIntegrationTests: XCTestCase {
      func testCalendarFetch() { }
      func testCalendarPermissions() { }
  }

  UI Tests:

  class LoginUITests: XCTestCase {
      func testActivationFlow() { }
      func testSettingsNavigation() { }
  }

  ### 4.21. Release Strategy

  Notarization:

  # Prepare
  xcodebuild -scheme AlcoveClone -configuration Release

  # Notarize
  xcrun notarytool submit AlcoveClone.app --apple-id "..." --password "..." --team-id "..."
  xcrun stapler staple AlcoveClone.app

  Distribution:

  - .app bundle
  - .dmg installer
  - .pkg installer
  - GitHub Releases
  - Direct download

  ### 4.22. Post-Release

  Maintenance:

  - Monitor crash reports (Crashlytics, Sentry)
  - Collect user feedback
  - Plan v2.1 features
  - Fix reported bugs

  Updates:

  - Version bump
  - Changelog
  - New features
  - Bug fixes

  ———

  ## 📋 PODSUMOWANIE

  Ten dokument zawiera kompletne wymagania, design, harmonogram i instrukcje dla budowy aplikacji Alcove
  Clone. Zgodnie z planem:

  - PRD: Pełne wymagania funkcjonalne i non-funkcjonalne
  - SDD: Architektura, modele danych, interfejsy API
  - Roadmap: Szczegółowy harmonogram z milestones
  - LLM Instructions: Kompleksowe instrukcje dla agenta

  Czas realizacji: ~4 tygodnie (27 dni roboczych)

  Wymagane umiejętności:

  - SwiftUI (zaawansowane)
  - macOS development
  - Xcode & Swift package manager
  - System APIs (Calendar, Music, Focus, Battery, BetterDisplay)
  - Notarization i code signing
  - Unit & UI testing

  Kluczowe wyzwania:

  1. Reverse engineering SwiftUI kodu (jeśli potrzeba)
  2. System licencji (implementacja od zera)
  3. BetterDisplay integration (API zmienia się)
  4. Notarization dla Apple

  Największe korzyści:

  - Pełna kontrola nad kodem
  - Brak ograniczeń licencyjnych
  - Możliwość dodawania własnych funkcji
  - Edukacyjna wartość (Reverse engineering + native dev)