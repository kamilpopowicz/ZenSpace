import AppKit
import Foundation

final class SoundService {
    enum Sound: String {
        case lock
        case unlock
        case lowBattery = "low-battery"
        case lowPower = "low-power"
        case chime
        case sleep
    }

    func play(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "caf")
                ?? Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") else { return }
        NSSound(contentsOf: url, byReference: true)?.play()
    }

    func startLockScreenObservation() {
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleLock),
            name: NSNotification.Name("com.apple.screenIsLocked"),
            object: nil
        )
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleUnlock),
            name: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )
    }

    func stopObservation() {
        DistributedNotificationCenter.default().removeObserver(self)
    }

    deinit {
        stopObservation()
    }

    @objc private func handleLock() {
        play(.lock)
    }

    @objc private func handleUnlock() {
        play(.unlock)
    }
}
