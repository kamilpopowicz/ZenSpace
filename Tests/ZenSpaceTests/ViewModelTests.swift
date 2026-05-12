import XCTest
@testable import ZenSpace

@MainActor
final class ViewModelTests: XCTestCase {

    // MARK: - LicenseViewModel

    func testLicenseVMInitialStatus() {
        let vm = LicenseViewModel()
        vm.checkStatus()
        XCTAssertEqual(vm.status, .licensed) // bypass
    }

    func testLicenseVMActivateEmptyKey() {
        let vm = LicenseViewModel()
        vm.licenseKey = ""
        vm.activate()
        XCTAssertNotNil(vm.errorMessage)
    }

    func testLicenseVMActivateValidKey() {
        let vm = LicenseViewModel()
        vm.licenseKey = "VALID-KEY-123"
        vm.activate()
        XCTAssertNil(vm.errorMessage)
        XCTAssertEqual(vm.status, .licensed)
        XCTAssertEqual(vm.licenseKey, "")
    }

    func testLicenseVMStartTrial() {
        let vm = LicenseViewModel()
        vm.startTrial()
        XCTAssertEqual(vm.status, .licensed) // bypass
    }

    // MARK: - CalendarViewModel

    func testCalendarVMInitialState() {
        let vm = CalendarViewModel()
        XCTAssertTrue(vm.todayEvents.isEmpty)
        XCTAssertTrue(vm.tomorrowEvents.isEmpty)
        XCTAssertFalse(vm.isLoading)
    }

    func testCalendarVMSections() {
        let vm = CalendarViewModel()
        XCTAssertTrue(vm.todaySection.isEmpty)
        XCTAssertEqual(vm.todaySection.title, "Today")
        XCTAssertEqual(vm.tomorrowSection.title, "Tomorrow")
    }

    // MARK: - MediaViewModel

    func testMediaVMInitialState() {
        let vm = MediaViewModel()
        XCTAssertNil(vm.metadata)
        XCTAssertFalse(vm.isPlaying)
        XCTAssertFalse(vm.hasMedia)
        XCTAssertEqual(vm.artist, "")
        XCTAssertEqual(vm.album, "")
    }

    func testMediaVMTogglePlayPause() {
        let vm = MediaViewModel()
        let initial = vm.isPlaying
        vm.togglePlayPause()
        XCTAssertNotEqual(vm.isPlaying, initial)
    }

    // MARK: - FocusViewModel

    func testFocusVMInitialState() {
        let vm = FocusViewModel()
        XCTAssertNil(vm.currentMode)
        XCTAssertFalse(vm.isActive)
    }

    func testFocusVMModeIcon() {
        let vm = FocusViewModel()
        // No mode active
        XCTAssertEqual(vm.modeIcon, "moon.fill")
    }

    // MARK: - BatteryViewModel

    func testBatteryVMInitialState() {
        let vm = BatteryViewModel()
        XCTAssertEqual(vm.level, 100)
        XCTAssertFalse(vm.isCharging)
        XCTAssertFalse(vm.isLowBattery)
    }

    func testBatteryVMIconLogic() {
        let vm = BatteryViewModel()
        // Default level 100, not charging
        XCTAssertEqual(vm.icon, "battery.100")
    }
}
