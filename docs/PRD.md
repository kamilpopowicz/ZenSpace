# PRD (Product Requirements Document) - ZenSpace

## 1.1. Tytuł projektu
Alcove Clone - Personal Focus & Notification Manager for macOS

## 1.2. Dokumentacja wersji
- Wersja: 1.0
- Data: 2026-05-08
- Status: Wersja robocza
- Autor: Zespół developmentowy

## 1.3. Abstrakt
Aplikacja macOS typu "focus manager" i "notification hub" inspirowana Alcove, z pełnym systemem licencji, integracją z BetterDisplay, kalendarzem i systemem powiadomień.

## 1.4. Cel projektu
1. Stworzenie aplikacji macOS do zarządzania koncentracją
2. Implementacja pełnego systemu licencji (Trial + Pro)
3. Integracja z BetterDisplay i systemem powiadomień
4. Monitoring muzyki w trakcie odtwarzania
5. System focus modes

## 1.5. Użytkownik docelowy
- Osoby pracujące samodzielnie (freelancerzy, developers, designers)
- Użytkownicy którzy potrzebują zarządzania koncentracją
- Osoby używające BetterDisplay
- Użytkownicy którzy chcą kontrolować powiadomienia

## 1.6. Wymagania funkcjonalne

### 1.6.1. Licencjonowanie
- Trial period: 72 hours
- Full activation via license key
- Limit 3 devices
- License recovery via web
- Device management

### 1.6.2. Kalendarz
- Display events (Today, Tomorrow)
- Event notifications
- TimeToLeave notifications
- Calendar permissions
- Chime (hourly sound)
- Sound on event
- Disable activity during events
- Transport mode (Driving, Transit, Walking)
- Weather on empty day
- Colored indicators

### 1.6.3. Media/Now Playing
- Play/Pause/Next/Previous controls
- PlaybackSpeed control
- Display metadata (title, artist, album)
- Copy link
- Quick Peek

### 1.6.4. Focus Modes
- 10 focus modes:
    - Do Not Disturb, Driving, Fitness, Gaming, Mindfulness, Personal, Reading, Sleep, Work, Reduce Interruptions

### 1.6.5. Bateria
- Low battery notifications
- Low power mode notifications
- Low battery threshold setting
- Warn on low battery
- Play sound on low battery
- Hide percentage

### 1.6.6. BetterDisplay Integration
- BetterDisplay detection
- BetterDisplay launching
- BetterDisplay notifications (launched, terminated, OSD)
- BetterDisplay requests
- Active display detection

### 1.6.7. Lock Screen Sounds
- Sound on lock/unlock
- Sound on low battery
- Sound on sleep focus
- Sound on time to leave

### 1.6.8. System Integration
- BluetoothManager
- NowPlaying observation
- Calendar permissions
- Music permissions
- Display settings

### 1.6.9. UI/UX
- SwiftUI interface
- Minimalistic design
- Glass effect
- Progressive blur
- Quick Peek animations
- Expanded view on hover
- Notifications in notch
- Live activities support

## 1.7. Non-functional requirements
- Start aplikacji < 2 sekundy
- Reakcja na powiadomienia < 500ms
- Memory usage < 200MB
- macOS 12.0+ compatibility
- Universal binary (x86_64 + arm64)
- VoiceOver support, Dynamic type support, High contrast mode
