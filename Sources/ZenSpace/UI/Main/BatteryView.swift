import SwiftUI

@MainActor
final class BatteryViewModel: ObservableObject {
    @Published var level: Int = 100
    @Published var isCharging: Bool = false
    @Published var isLowBattery: Bool = false

    @AppStorage("warnOnLowBattery") private var warnEnabled = true
    @AppStorage("lowBatteryThreshold") private var threshold = 20
    @AppStorage("playSoundOnLowBattery") private var playSoundEnabled = true
    @AppStorage("hidePercentage") private var hidePercentage = false

    private let batteryService = BatteryService()
    private let soundService = SoundService()
    private var lowBatteryNotified = false
    private var observer: NSObjectProtocol?

    var showPercentage: Bool { !hidePercentage }

    var icon: String {
        if isCharging { return "battery.100.bolt" }
        if level > 75 { return "battery.100" }
        if level > 50 { return "battery.75" }
        if level > 25 { return "battery.50" }
        return "battery.25"
    }

    var color: Color {
        if isCharging { return .green }
        if level <= threshold { return .red }
        if level <= threshold + 20 { return .orange }
        return .primary
    }

    func start() {
        batteryService.startMonitoring()
        soundService.startLockScreenObservation()

        observer = NotificationCenter.default.addObserver(
            forName: BatteryService.batteryChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.update() }
        }
        update()
    }

    deinit {
        if let observer { NotificationCenter.default.removeObserver(observer) }
        batteryService.stopMonitoring()
    }

    private func update() {
        level = batteryService.level
        isCharging = batteryService.isCharging
        isLowBattery = batteryService.isLowBattery(threshold: threshold)

        guard warnEnabled else { return }

        if isLowBattery && !lowBatteryNotified {
            if playSoundEnabled {
                soundService.play(.lowBattery)
            }
            lowBatteryNotified = true
        } else if !isLowBattery {
            lowBatteryNotified = false
        }
    }
}

struct BatteryView: View {
    @StateObject private var viewModel = BatteryViewModel()

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: viewModel.icon)
                .foregroundStyle(viewModel.color)
                .font(.caption)

            if viewModel.showPercentage {
                Text("\(viewModel.level)%")
                    .font(.caption)
                    .foregroundStyle(viewModel.color)
            }

            Spacer()

            if viewModel.isCharging {
                Text(L("notification.battery.charging"))
                    .font(.caption2)
                    .foregroundStyle(.green)
            } else if viewModel.isLowBattery {
                Text(L("notification.battery.lowBattery"))
                    .font(.caption2)
                    .foregroundStyle(.red)
            }
        }
        .onAppear { viewModel.start() }
    }
}
