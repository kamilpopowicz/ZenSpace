import AppKit
import Foundation

final class DisplayService {
    static let displayChanged = Notification.Name("com.zenspace.displayChanged")

    private let bundleID = "pro.betterdisplay.BetterDisplay"
    private var observer: NSObjectProtocol?

    private(set) var isBetterDisplayRunning: Bool = false

    func startMonitoring() {
        checkRunning()
        observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let app = note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                  app.bundleIdentifier == self?.bundleID else { return }
            self?.isBetterDisplayRunning = true
            self?.postNotification(type: .launched)
        }

        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didTerminateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let app = note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                  app.bundleIdentifier == self?.bundleID else { return }
            self?.isBetterDisplayRunning = false
            self?.postNotification(type: .terminated)
        }

        // Listen for BetterDisplay OSD notifications
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleOSD(_:)),
            name: NSNotification.Name("com.betterdisplay.OSD"),
            object: nil
        )
    }

    func stopMonitoring() {
        if let observer { NSWorkspace.shared.notificationCenter.removeObserver(observer) }
        DistributedNotificationCenter.default().removeObserver(self)
    }

    func launchBetterDisplay() {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) else { return }
        NSWorkspace.shared.openApplication(at: url, configuration: .init())
    }

    private func checkRunning() {
        isBetterDisplayRunning = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == bundleID
        }
    }

    @objc private func handleOSD(_ notification: Notification) {
        postNotification(type: .osd)
    }

    private func postNotification(type: NotificationType) {
        NotificationCenter.default.post(name: Self.displayChanged, object: type)
    }
}
