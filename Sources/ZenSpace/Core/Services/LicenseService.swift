import Foundation

final class LicenseService {
    // MARK: - Bypass (set to false to enable license checking)
    static let LICENSE_BYPASS = true

    private let repository = LicenseRepository()
    private let trialKey = "zenspace_trial_start"

    func checkStatus() -> LicenseStatus {
        if Self.LICENSE_BYPASS { return .licensed }

        if let license = repository.load() {
            if let expiry = license.expiryDate, expiry < Date() {
                return .expired
            }
            return .licensed
        }

        if let trialStart = UserDefaults.standard.object(forKey: trialKey) as? Date {
            let hours = Int(Date().timeIntervalSince(trialStart) / 3600)
            let remaining = max(0, 72 - hours)
            return remaining > 0 ? .trial(remainingHours: remaining) : .expired
        }

        return .unlicensed
    }

    func startTrial() {
        UserDefaults.standard.set(Date(), forKey: trialKey)
    }

    func activate(key: String) -> Bool {
        if Self.LICENSE_BYPASS { return true }

        let license = License(
            licenseKey: key,
            deviceId: hardwareUUID(),
            deviceName: Host.current().localizedName,
            createdAt: Date(),
            expiryDate: nil,
            maxDevices: 3,
            activeDevices: 1
        )
        return repository.save(license)
    }

    func deactivate() -> Bool {
        repository.remove()
    }

    func currentLicense() -> License? {
        repository.load()
    }

    private func hardwareUUID() -> String {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        defer { IOObjectRelease(service) }
        guard let uuid = IORegistryEntryCreateCFProperty(service, "IOPlatformUUID" as CFString, kCFAllocatorDefault, 0)?
            .takeRetainedValue() as? String else {
            return UUID().uuidString
        }
        return uuid
    }
}
