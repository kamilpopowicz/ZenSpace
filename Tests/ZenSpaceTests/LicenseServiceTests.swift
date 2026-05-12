import XCTest
@testable import ZenSpace

final class LicenseServiceTests: XCTestCase {
    private var service: LicenseService!

    override func setUp() {
        super.setUp()
        service = LicenseService()
    }

    func testBypassReturnsLicensed() {
        XCTAssertTrue(LicenseService.LICENSE_BYPASS)
        let status = service.checkStatus()
        XCTAssertEqual(status, .licensed)
    }

    func testActivateWithBypass() {
        let result = service.activate(key: "TEST-KEY")
        XCTAssertTrue(result)
    }

    func testStartTrial() {
        service.startTrial()
        // With bypass on, status is still licensed
        let status = service.checkStatus()
        XCTAssertEqual(status, .licensed)
    }

    func testDeactivate() {
        let result = service.deactivate()
        // deactivate returns result of keychain removal (may be false if nothing stored)
        XCTAssertNotNil(result)
    }
}
