import XCTest
@testable import ZenSpace

final class BatteryServiceTests: XCTestCase {
    private var service: BatteryService!

    override func setUp() {
        super.setUp()
        service = BatteryService()
    }

    override func tearDown() {
        service.stopMonitoring()
        super.tearDown()
    }

    func testInitialLevel() {
        // Before refresh, level defaults to 100
        XCTAssertEqual(service.level, 100)
    }

    func testRefreshUpdatesLevel() {
        service.refresh()
        // After refresh, level should be between 0-100
        XCTAssertGreaterThanOrEqual(service.level, 0)
        XCTAssertLessThanOrEqual(service.level, 100)
    }

    func testIsLowBatteryThreshold() {
        service.refresh()
        // isLowBattery depends on actual battery state
        let result = service.isLowBattery(threshold: 0)
        XCTAssertFalse(result) // threshold 0 should never trigger
    }

    func testStartStopMonitoring() {
        service.startMonitoring()
        // Should not crash
        service.stopMonitoring()
    }
}

final class FocusServiceTests: XCTestCase {
    private var service: FocusService!

    override func setUp() {
        super.setUp()
        service = FocusService()
    }

    override func tearDown() {
        service.stopMonitoring()
        super.tearDown()
    }

    func testGetCurrentModeReturnsOptional() {
        let mode = service.getCurrentMode()
        // Mode is nil when DND is off, or .doNotDisturb when on
        if let mode {
            XCTAssertEqual(mode, .doNotDisturb)
        } else {
            XCTAssertNil(mode)
        }
    }

    func testStartStopMonitoring() {
        service.startMonitoring()
        service.stopMonitoring()
        // Should not crash or leak
    }
}
