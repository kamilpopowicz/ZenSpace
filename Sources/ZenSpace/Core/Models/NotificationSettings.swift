import Foundation

struct NotificationSettings: Codable {
    // Battery
    var lowBatteryEnabled: Bool
    var lowBatteryThreshold: Int
    var lowPowerModeEnabled: Bool
    var lowPowerSoundEnabled: Bool
    var hideBatteryPercentage: Bool

    // Calendar
    var calendarEnabled: Bool
    var calendarPermissions: [String]
    var chimeEnabled: Bool
    var soundOnEventEnabled: Bool
    var soundOnNotificationEnabled: Bool
    var disableActivityDuringEvents: Bool
    var timeToLeaveEnabled: Bool
    var transportMode: TransportMode
    var showWeatherOnEmptyDay: Bool
    var timeBeforeEvent: Int

    // Lock Screen
    var soundOnLock: Bool
    var soundOnUnlock: Bool
    var soundOnSleepFocus: Bool
    var soundOnTimeToLeave: Bool

    // Media
    var nowPlayingEnabled: Bool
    var quickPeekEnabled: Bool

    // Focus
    var focusSoundEnabled: Bool
}

extension NotificationSettings {
    static let `default` = NotificationSettings(
        lowBatteryEnabled: true,
        lowBatteryThreshold: 20,
        lowPowerModeEnabled: true,
        lowPowerSoundEnabled: true,
        hideBatteryPercentage: false,
        calendarEnabled: true,
        calendarPermissions: [],
        chimeEnabled: false,
        soundOnEventEnabled: true,
        soundOnNotificationEnabled: true,
        disableActivityDuringEvents: false,
        timeToLeaveEnabled: true,
        transportMode: .driving,
        showWeatherOnEmptyDay: true,
        timeBeforeEvent: 15,
        soundOnLock: true,
        soundOnUnlock: true,
        soundOnSleepFocus: true,
        soundOnTimeToLeave: true,
        nowPlayingEnabled: true,
        quickPeekEnabled: true,
        focusSoundEnabled: true
    )
}
