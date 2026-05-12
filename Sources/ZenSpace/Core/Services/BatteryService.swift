import Foundation
import IOKit.ps

final class BatteryService {
    static let batteryChanged = Notification.Name("com.zenspace.batteryChanged")

    private var timer: Timer?
    private(set) var level: Int = 100
    private(set) var isCharging: Bool = false
    private(set) var isLowPowerMode: Bool = false

    func startMonitoring() {
        refresh()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    func refresh() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [Any],
              let source = sources.first,
              let info = IOPSGetPowerSourceDescription(snapshot, source as CFTypeRef)?.takeUnretainedValue() as? [String: Any]
        else { return }

        level = info[kIOPSCurrentCapacityKey] as? Int ?? level
        let state = info[kIOPSPowerSourceStateKey] as? String
        isCharging = state == kIOPSACPowerValue
        isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled

        NotificationCenter.default.post(name: Self.batteryChanged, object: nil)
    }

    func isLowBattery(threshold: Int = 20) -> Bool {
        !isCharging && level <= threshold
    }
}
