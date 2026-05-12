import XCTest
@testable import ZenSpace

final class ModelTests: XCTestCase {

    // MARK: - License

    func testLicenseEncoding() throws {
        let license = License(
            licenseKey: "TEST-KEY-123",
            deviceId: "device-1",
            deviceName: "MacBook",
            createdAt: Date(),
            expiryDate: nil,
            maxDevices: 3,
            activeDevices: 1
        )
        let data = try JSONEncoder().encode(license)
        let decoded = try JSONDecoder().decode(License.self, from: data)
        XCTAssertEqual(decoded.licenseKey, "TEST-KEY-123")
        XCTAssertEqual(decoded.deviceId, "device-1")
        XCTAssertEqual(decoded.maxDevices, 3)
    }

    func testLicenseStatusBypass() {
        XCTAssertEqual(LicenseStatus.current, .licensed)
    }

    func testLicenseStatusCodable() throws {
        let statuses: [LicenseStatus] = [.licensed, .trial(remainingHours: 48), .expired, .unlicensed]
        for status in statuses {
            let data = try JSONEncoder().encode(status)
            let decoded = try JSONDecoder().decode(LicenseStatus.self, from: data)
            XCTAssertEqual(decoded, status)
        }
    }

    // MARK: - CalendarEvent

    func testCalendarEventIdentifiable() {
        let event = CalendarEvent(
            id: "evt-1",
            title: "Meeting",
            location: "Room 1",
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            isAllDay: false,
            calendarColor: "#FF0000",
            isTomorrow: false,
            isPast: false,
            isUpcoming: true
        )
        XCTAssertEqual(event.id, "evt-1")
        XCTAssertEqual(event.title, "Meeting")
        XCTAssertFalse(event.isAllDay)
    }

    func testEventSectionEmpty() {
        let section = EventSection(title: "Today", events: [])
        XCTAssertTrue(section.isEmpty)
        XCTAssertEqual(section.id, "Today")
    }

    func testTransportModeAllCases() {
        XCTAssertEqual(TransportMode.allCases.count, 3)
        XCTAssertTrue(TransportMode.allCases.contains(.driving))
        XCTAssertTrue(TransportMode.allCases.contains(.transit))
        XCTAssertTrue(TransportMode.allCases.contains(.walking))
    }

    // MARK: - FocusMode

    func testFocusModeAllCases() {
        XCTAssertEqual(FocusMode.allCases.count, 10)
    }

    func testFocusModeRawValues() {
        XCTAssertEqual(FocusMode.doNotDisturb.rawValue, "doNotDisturb")
        XCTAssertEqual(FocusMode.reduceInterruptions.rawValue, "reduceInterruptions")
    }

    func testFocusModeSettings() throws {
        let settings = FocusModeSettings(
            mode: .work,
            isEnabled: true,
            autoActivate: false,
            soundEnabled: true,
            disableNotifications: true,
            disableDND: false
        )
        let data = try JSONEncoder().encode(settings)
        let decoded = try JSONDecoder().decode(FocusModeSettings.self, from: data)
        XCTAssertEqual(decoded.mode, .work)
        XCTAssertTrue(decoded.isEnabled)
        XCTAssertTrue(decoded.disableNotifications)
    }

    // MARK: - MediaMetadata

    func testPlaybackStateRawValues() {
        XCTAssertEqual(PlaybackState.playing.rawValue, "playing")
        XCTAssertEqual(PlaybackState.paused.rawValue, "paused")
        XCTAssertEqual(PlaybackState.stopped.rawValue, "stopped")
        XCTAssertEqual(PlaybackState.buffering.rawValue, "buffering")
    }

    func testMediaMetadataEncoding() throws {
        let metadata = MediaMetadata(
            title: "Song",
            artist: "Artist",
            album: "Album",
            albumArtwork: nil,
            playbackState: .playing,
            playbackPosition: 120.5,
            playbackSpeed: 1.0,
            isDolbyAtmos: false
        )
        let data = try JSONEncoder().encode(metadata)
        let decoded = try JSONDecoder().decode(MediaMetadata.self, from: data)
        XCTAssertEqual(decoded.title, "Song")
        XCTAssertEqual(decoded.artist, "Artist")
        XCTAssertEqual(decoded.playbackState, .playing)
        XCTAssertEqual(decoded.playbackSpeed, 1.0)
    }

    // MARK: - NotificationSettings

    func testNotificationSettingsDefault() {
        let settings = NotificationSettings.default
        XCTAssertTrue(settings.lowBatteryEnabled)
        XCTAssertEqual(settings.lowBatteryThreshold, 20)
        XCTAssertTrue(settings.calendarEnabled)
        XCTAssertEqual(settings.transportMode, .driving)
        XCTAssertTrue(settings.nowPlayingEnabled)
        XCTAssertTrue(settings.focusSoundEnabled)
        XCTAssertEqual(settings.timeBeforeEvent, 15)
    }

    func testNotificationSettingsCodable() throws {
        let settings = NotificationSettings.default
        let data = try JSONEncoder().encode(settings)
        let decoded = try JSONDecoder().decode(NotificationSettings.self, from: data)
        XCTAssertEqual(decoded.lowBatteryThreshold, settings.lowBatteryThreshold)
        XCTAssertEqual(decoded.transportMode, settings.transportMode)
    }

    // MARK: - DisplaySettings

    func testDisplaySettingsDefault() {
        let settings = DisplaySettings.default
        XCTAssertTrue(settings.betterDisplayIntegration)
        XCTAssertTrue(settings.betterDisplayOSD)
    }

    func testNotificationTypeRawValues() {
        XCTAssertEqual(NotificationType.launched.rawValue, "launched")
        XCTAssertEqual(NotificationType.terminated.rawValue, "terminated")
        XCTAssertEqual(NotificationType.osd.rawValue, "osd")
    }
}

// MARK: - Equatable conformance for test assertions

extension LicenseStatus: Equatable {
    public static func == (lhs: LicenseStatus, rhs: LicenseStatus) -> Bool {
        switch (lhs, rhs) {
        case (.licensed, .licensed): return true
        case (.trial(let a), .trial(let b)): return a == b
        case (.expired, .expired): return true
        case (.unlicensed, .unlicensed): return true
        default: return false
        }
    }
}
