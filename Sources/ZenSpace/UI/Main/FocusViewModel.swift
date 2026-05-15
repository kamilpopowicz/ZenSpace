import Foundation
import SwiftUI

@MainActor
final class FocusViewModel: ObservableObject {
    @Published var currentMode: FocusMode?
    @Published var isActive: Bool = false

    private let service = FocusService()
    private var observer: NSObjectProtocol?

    var modeName: String {
        guard let mode = currentMode else { return L("common.off") }
        return L("focus.\(mode.rawValue)")
    }

    var modeIcon: String {
        guard let mode = currentMode else { return "moon.fill" }
        switch mode {
        case .doNotDisturb: return "moon.fill"
        case .driving: return "car.fill"
        case .fitness: return "figure.run"
        case .gaming: return "gamecontroller.fill"
        case .mindfulness: return "brain.head.profile"
        case .personal: return "person.fill"
        case .reading: return "book.fill"
        case .sleep: return "bed.double.fill"
        case .work: return "laptopcomputer"
        case .reduceInterruptions: return "bell.slash.fill"
        }
    }

    func start() {
        service.startMonitoring()
        observer = NotificationCenter.default.addObserver(
            forName: FocusService.focusChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            Task { @MainActor in
                self?.currentMode = notification.object as? FocusMode
                self?.isActive = self?.currentMode != nil
            }
        }
    }

    func stop() {
        service.stopMonitoring()
    }

    deinit {
        if let observer { NotificationCenter.default.removeObserver(observer) }
        service.stopMonitoring()
    }
}
