import Foundation
import AppKit

final class FocusService {
    static let focusChanged = Notification.Name("com.zenspace.focusChanged")

    private var timer: Timer?

    func startMonitoring() {
        checkCurrentMode()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkCurrentMode()
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    func getCurrentMode() -> FocusMode? {
        // Uses NSDoNotDisturbEnabled from UserDefaults (com.apple.controlcenter)
        // For full Focus mode detection, we check the DND state
        let dndEnabled = isDNDEnabled()
        return dndEnabled ? .doNotDisturb : nil
    }

    private func isDNDEnabled() -> Bool {
        // Check DND via distributed notification center defaults
        guard let defaults = UserDefaults(suiteName: "com.apple.controlcenter") else { return false }
        return defaults.bool(forKey: "NSDoNotDisturbEnabled")
    }

    private func checkCurrentMode() {
        NotificationCenter.default.post(name: Self.focusChanged, object: getCurrentMode())
    }
}
