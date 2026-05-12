import Foundation

// MARK: - License Model (INACTIVE - will be activated in M3)
// Models are defined but license checking is disabled.
// The app runs as fully unlocked until LicenseService is implemented.

struct License: Codable {
    let licenseKey: String
    let deviceId: String
    let deviceName: String?
    let createdAt: Date
    let expiryDate: Date?
    let maxDevices: Int
    let activeDevices: Int
}

enum LicenseStatus: Codable {
    case licensed
    case trial(remainingHours: Int)
    case expired
    case unlicensed

    // MARK: - Bypass (remove in M3)
    static var current: LicenseStatus { .licensed }
}
