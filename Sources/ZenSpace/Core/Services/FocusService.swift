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
        if isDNDEnabled() { return .doNotDisturb }
        return nil
    }

    private func isDNDEnabled() -> Bool {
        // macOS 13+: DND state is stored in Focus assertions plist
        let assertionsPath = NSHomeDirectory() + "/Library/DoNotDisturb/DB/Assertions.json"
        if FileManager.default.fileExists(atPath: assertionsPath),
           let data = try? Data(contentsOf: URL(fileURLWithPath: assertionsPath)),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let storeAssertions = json["data"] as? [[String: Any]],
           !storeAssertions.isEmpty {
            return true
        }

        // Fallback: check via DistributedNotificationCenter state
        // macOS 12 legacy path
        if let defaults = UserDefaults(suiteName: "com.apple.controlcenter"),
           defaults.bool(forKey: "NSDoNotDisturbEnabled") {
            return true
        }

        // macOS 13+ alternative: check via Focus status mirror
        let mirrorPath = NSHomeDirectory() + "/Library/DoNotDisturb/DB/ModeConfigurations.json"
        if FileManager.default.fileExists(atPath: mirrorPath),
           let data = try? Data(contentsOf: URL(fileURLWithPath: mirrorPath)),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let modeData = json["data"] as? [[String: Any]] {
            for mode in modeData {
                if let triggers = mode["triggers"] as? [String: Any],
                   let enabled = triggers["enabledSetting"] as? Int,
                   enabled == 2 {
                    return true
                }
            }
        }

        return false
    }

    private func checkCurrentMode() {
        NotificationCenter.default.post(name: Self.focusChanged, object: getCurrentMode())
    }
}
