import SwiftUI

@MainActor
final class DisplayViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var lastEvent: NotificationType?

    private let service = DisplayService()
    private var observer: NSObjectProtocol?

    func start() {
        service.startMonitoring()
        isRunning = service.isBetterDisplayRunning

        observer = NotificationCenter.default.addObserver(
            forName: DisplayService.displayChanged,
            object: nil,
            queue: .main
        ) { [weak self] note in
            Task { @MainActor in
                guard let type = note.object as? NotificationType else { return }
                self?.lastEvent = type
                self?.isRunning = self?.service.isBetterDisplayRunning ?? false
            }
        }
    }

    func launch() {
        service.launchBetterDisplay()
    }

    deinit {
        if let observer { NotificationCenter.default.removeObserver(observer) }
        service.stopMonitoring()
    }
}

struct DisplayView: View {
    @StateObject private var viewModel = DisplayViewModel()

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "display")
                .font(.caption)
                .foregroundStyle(viewModel.isRunning ? .primary : .secondary)

            Text("BetterDisplay")
                .font(.caption)

            Spacer()

            if viewModel.isRunning {
                Circle()
                    .fill(.green)
                    .frame(width: 6, height: 6)
            } else {
                Button {
                    viewModel.launch()
                } label: {
                    Text("common.install")
                        .font(.caption2)
                }
                .buttonStyle(.bordered)
                .controlSize(.mini)
            }
        }
        .onAppear { viewModel.start() }
    }
}
