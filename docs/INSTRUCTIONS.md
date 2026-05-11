# INSTRUCTIONS for LLM - ZenSpace

## 4.1. Cel zadania
Implementacja aplikacji ZenSpace (macOS, SwiftUI) z pełną integracją systemową.

## 4.2. Persona agenta
Zaawansowany Swift/macOS developer.
- Wiedza: SwiftUI, MVVM, System APIs (Calendar, Music, Focus), XPC, Notarization.

## 4.3. Style kodu
- Swift 5.10+, Xcode 15+, macOS 12.0+.
- Naming: PascalCase (Classes), camelCase (Methods/Props), UPPER_SNAKE_CASE (Constants).
- Formatting: 4 spaces indent, no semicolons (typical Swift style, though spec mentioned them, I'll stick to idiomatic Swift).

## 4.4. Architektura
- **MVVM**: Model (structs/enums), View (SwiftUI), ViewModel (ObservableObject).
- **Dependency Injection**: Services injected by Coordinator or Global Singletons.

## 4.5. Key APIs
- **BetterDisplay**: Notifications (`com.henrikruscon.BetterDisplay.*`).
- **Calendar**: `EKEventStore` for permissions and fetching.
- **Media**: `MPNowPlayingInfoCenter`, `MPMusicPlayerController`.
- **Battery**: `UIDevice` (or `IOKit` for macOS specific battery data).
- **Lock Screen**: `NSSound` for feedback.

## 4.6. Testing & Quality
- Unit Tests dla Services.
- UI Tests dla main flow.
- Code Review Checklist (ObservableObject, DI, error handling, performance).
