# QA Checklist — ZenSpace

## 🤖 Testy automatyczne (CI / terminal)

### Unit Tests (38 testów) — ✅ ALL PASS
- [x] ModelTests (15) — encoding/decoding, defaults, allCases
- [x] LicenseServiceTests (4) — bypass, activate, trial, deactivate
- [x] ServiceTests (6) — BatteryService, FocusService lifecycle
- [x] ViewModelTests (12) — initial states, logic, controls

### Smoke Test (terminal) — ✅ PASS
- [x] `swift run` — apka uruchamia się bez crash
- [x] Proces żyje przez 5s bez SIGABRT/SIGSEGV
- [x] stderr nie zawiera "fatal error" / "assertion failed"
- [x] Exit code 0 po graceful kill

### Walidacja lokalizacji — ✅ PASS
- [x] Wszystkie klucze z `en.lproj` istnieją w `pl.lproj` (264 = 264)
- [x] Wszystkie klucze z `pl.lproj` istnieją w `en.lproj`
- [x] Brak pustych wartości w obu plikach
- [x] Format specifiers (%@, %lld) zgadzają się między językami (35 = 35)

### Build verification — ✅ PASS
- [x] `swift build` — 0 errors, 0 warnings
- [x] `swift build -c release` — release build przechodzi
- [x] `swift test` — wszystkie 38 testów pass

---

## 🧑‍💻 Testy manualne (Kamil)

### Uruchomienie
- [ ] Apka pojawia się w menu bar (ikona brain.head.profile)
- [ ] Kliknięcie ikony otwiera popup window
- [ ] Popup ma glass effect (przezroczyste tło)
- [ ] Apka NIE pojawia się w Docku (LSUIElement = true)

### Kalendarz
- [ ] Widoczny przycisk "Grant Permission" jeśli brak uprawnień
- [ ] Po przyznaniu uprawnień — wyświetla wydarzenia z dzisiaj
- [ ] Wydarzenia z jutra w sekcji "Tomorrow"
- [ ] Kolorowe wskaźniki przy wydarzeniach
- [ ] Pusty stan: "Your day is clear"
- [ ] Przeszłe wydarzenia wyszarzone (opacity 0.5)

### Media / Now Playing
- [ ] Wyświetla "Not Playing" gdy nic nie gra
- [ ] Po włączeniu muzyki — pokazuje tytuł + artysta
- [ ] Artwork (okładka) wyświetla się
- [ ] Przycisk Play/Pause działa
- [ ] Przycisk Next/Previous działa
- [ ] Zmiana utworu aktualizuje metadata

### Focus Modes
- [ ] Pokazuje "Off" gdy brak aktywnego trybu
- [ ] Włączenie DND w System Settings → ZenSpace pokazuje "Do Not Disturb"
- [ ] Zielona kropka przy aktywnym trybie

### Bateria
- [ ] Wyświetla aktualny % baterii
- [ ] Ikona zmienia się wg poziomu (100/75/50/25)
- [ ] Status "Charging" gdy podłączony
- [ ] Kolor czerwony przy ≤20%

### BetterDisplay
- [ ] Pokazuje status "running" jeśli BetterDisplay jest uruchomiony
- [ ] Przycisk "Install" jeśli nie jest uruchomiony
- [ ] Zielona kropka przy aktywnym BetterDisplay

### Lock Screen Sounds
- [ ] Dźwięk przy zablokowaniu ekranu (Ctrl+Cmd+Q)
- [ ] Dźwięk przy odblokowaniu

### Settings
- [ ] Cmd+, otwiera okno Settings
- [ ] 7 tabów widocznych (General, Calendar, NowPlaying, Battery, Focus, License, About)
- [ ] Toggle'e zapisują stan (restart apki → wartości zachowane)
- [ ] Tab License pokazuje "Your license has been activated"

### Lokalizacja
- [ ] System w języku polskim → UI po polsku
- [ ] System w języku angielskim → UI po angielsku
- [ ] Brak "kluczy" wyświetlanych zamiast tłumaczeń

### Stabilność
- [ ] Apka działa 10 minut bez crash
- [ ] Wielokrotne otwieranie/zamykanie popup nie crashuje
- [ ] Przełączanie focus modes nie crashuje
- [ ] Odłączenie/podłączenie ładowarki nie crashuje

---

## 📋 Znane ograniczenia (nie są bugami)
- License system jest bypassed (zawsze "licensed")
- Focus detection wykrywa tylko DND (nie inne tryby)
- Notarization wyłączona (brak APP_PASSWORD)
- XPC Helper — protokół zdefiniowany, ale helper nie jest osobnym procesem
