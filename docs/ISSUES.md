# Issues Backlog

## v1.x — Do zrobienia teraz

### P1 — High (blokuje normalne użytkowanie)

#### #1 — Battery: wire warnOnLowBattery toggle [v1.3.0]
BatteryViewModel zawsze ostrzega niezależnie od ustawienia.
- Toggle OFF = brak ostrzeżenia
- Toggle ON = ostrzegaj jak dotychczas

#### #2 — Battery: wire lowBatteryThreshold setting [v1.3.0]
BatteryService.isLowBattery() hardcoded na 20%. Powinien czytać z AppStorage.

#### #3 — Battery: wire playSoundOnLowBattery toggle [v1.3.0]
BatteryViewModel zawsze gra dźwięk. Powinien sprawdzać toggle.

#### #4 — Battery: wire hidePercentage toggle [v1.3.0]
BatteryView zawsze pokazuje %. Toggle powinien ukrywać tekst procentowy.

### P2 — Medium (UX improvement)

#### #5 — General: remove or disable hideMenuBarIcon [v1.4.0]
Ukrycie ikony = brak dostępu do apki. Usunąć do v2.0.0.

#### #6 — General: mark expandOnHover as Coming Soon [v1.4.0]
Nie ma sensu bez notch view.

#### #7 — General: mark hapticFeedback as Coming Soon [v1.4.0]
Brak implementacji haptics.

#### #8 — General: mark progressiveBlur as Coming Soon [v1.4.0]
Komponent istnieje ale nie jest warunkowo stosowany.

#### #9 — Calendar: mark playHourlyChime as Coming Soon [v1.5.0]
Brak timera co godzinę.

#### #10 — Calendar: mark playSoundOnEvent as Coming Soon [v1.5.0]
Brak obserwacji startu eventu.

#### #11 — Calendar: mark notifyWhenTimeToLeave as Coming Soon [v1.5.0]
Wymaga lokalizacji, kalkulacji czasu dojazdu.

#### #12 — Calendar: mark showWeatherOnEmptyDay as Coming Soon [v1.5.0]
Wymaga integracji z WeatherKit.

#### #13 — NowPlaying: mark quickPeekEnabled as Coming Soon [v1.5.0]
Quick Peek nie zaimplementowana.

#### #14 — NowPlaying: mark hideWhileSourceAppIsActive as Coming Soon [v1.5.0]
Wymaga detekcji aktywnej apki.

#### #15 — Focus: mark focusSoundEnabled as Coming Soon [v1.5.0]
Brak dźwięku przy zmianie focus.

#### #16 — Focus: mark soundOnSleepFocus as Coming Soon [v1.5.0]
Brak detekcji przejścia w tryb Sleep.

---

## v2.0.0 — Notch Integration

### P1 — Core

#### #17 — Replace MenuBarExtra with NotchWindowController [v2.0.0]
Custom NSWindow przy notchu. MenuBarExtra jako fallback.

#### #18 — Notch: expand on hover [v2.0.0]
Mouse tracking + animacje spring.

#### #19 — Notch: compact info display [v2.0.0]
Widget w notchu: now playing, focus, battery.

#### #20 — Notch: swipe gestures [v2.0.0]
Swipe horizontal = skip, vertical = toggle.

### P2 — Features

#### #21 — Implement haptic feedback [v2.0.0]
#### #22 — Implement progressive blur on notch [v2.0.0]
#### #23 — Implement expand on hover setting [v2.0.0]
#### #24 — Calendar: hourly chime [v2.0.0]
#### #25 — Calendar: time to leave notifications [v2.0.0]
#### #26 — Calendar: weather on empty day [v2.0.0]
#### #27 — NowPlaying: Quick Peek [v2.0.0]
#### #28 — NowPlaying: hide while source app active [v2.0.0]
#### #29 — Focus: sound on mode change [v2.0.0]
#### #30 — Hide menu bar icon with keyboard shortcut [v2.0.0]

---

## Version Plan

| Version | Issues | Scope |
|---------|--------|-------|
| v1.3.0 | #1–#4 | Battery toggles wired |
| v1.4.0 | #5–#8 | Remove/disable non-functional General toggles |
| v1.5.0 | #9–#16 | Mark remaining as Coming Soon |
| v2.0.0 | #17–#30 | Notch integration + all deferred features |
