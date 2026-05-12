import Foundation

enum NotificationType: String, Codable {
    case launched
    case terminated
    case osd
    case request
}

struct DisplaySettings: Codable {
    var betterDisplayIntegration: Bool
    var betterDisplayLaunched: Bool
    var betterDisplayTerminated: Bool
    var betterDisplayOSD: Bool

    static let `default` = DisplaySettings(
        betterDisplayIntegration: true,
        betterDisplayLaunched: true,
        betterDisplayTerminated: true,
        betterDisplayOSD: true
    )
}
