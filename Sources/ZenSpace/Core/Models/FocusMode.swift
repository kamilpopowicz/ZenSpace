import Foundation

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
    var isEnabled: Bool
    var autoActivate: Bool
    var soundEnabled: Bool
    var disableNotifications: Bool
    var disableDND: Bool
}
