import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsTab()
                .tabItem { Label("settings.tab.general", systemImage: "gear") }

            CalendarSettingsTab()
                .tabItem { Label("common.calendar", systemImage: "calendar") }

            NowPlayingSettingsTab()
                .tabItem { Label("common.nowPlaying", systemImage: "music.note") }

            BatterySettingsTab()
                .tabItem { Label("common.battery", systemImage: "battery.100") }

            FocusSettingsTab()
                .tabItem { Label("common.focus", systemImage: "moon.fill") }

            LicenseSettingsTab()
                .tabItem { Label("settings.tab.license", systemImage: "key.fill") }

            AboutSettingsTab()
                .tabItem { Label("settings.tab.about", systemImage: "info.circle") }
        }
        .frame(width: 500, height: 380)
    }
}

// MARK: - General

struct GeneralSettingsTab: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("expandOnHover") private var expandOnHover = true
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("progressiveBlur") private var progressiveBlur = true
    @AppStorage("hideMenuBarIcon") private var hideMenuBarIcon = false

    var body: some View {
        Form {
            Toggle("settings.general.launchAtLogin", isOn: $launchAtLogin)
            Toggle("settings.general.behaviour.expandOnHover", isOn: $expandOnHover)
            Toggle("settings.general.behaviour.haptics", isOn: $hapticFeedback)
            Toggle("settings.general.behaviour.progressiveBlur", isOn: $progressiveBlur)
            Toggle("settings.general.hideMenuBarIcon", isOn: $hideMenuBarIcon)
        }
        .padding()
    }
}

// MARK: - Calendar

struct CalendarSettingsTab: View {
    @AppStorage("calendarEnabled") private var calendarEnabled = true
    @AppStorage("chimeEnabled") private var chimeEnabled = false
    @AppStorage("soundOnEvent") private var soundOnEvent = true
    @AppStorage("timeToLeave") private var timeToLeave = true
    @AppStorage("showWeatherOnEmptyDay") private var showWeather = true

    var body: some View {
        Form {
            Toggle("settings.calendar.enableCalendar", isOn: $calendarEnabled)
            Toggle("settings.calendar.playHourlyChime", isOn: $chimeEnabled)
            Toggle("settings.calendar.playSoundOnEvent", isOn: $soundOnEvent)
            Toggle("settings.calendar.notifyWhenTimeToLeave", isOn: $timeToLeave)
            Toggle("settings.calendar.showWeatherOnEmptyDay", isOn: $showWeather)
        }
        .padding()
    }
}

// MARK: - Now Playing

struct NowPlayingSettingsTab: View {
    @AppStorage("nowPlayingEnabled") private var enabled = true
    @AppStorage("quickPeekEnabled") private var quickPeek = true
    @AppStorage("hideWhileSourceActive") private var hideWhileActive = false

    var body: some View {
        Form {
            Toggle("common.nowPlaying", isOn: $enabled)
            Toggle("common.quickPeek", isOn: $quickPeek)
            Toggle("settings.nowPlaying.hideWhileSourceAppIsActive", isOn: $hideWhileActive)
        }
        .padding()
    }
}

// MARK: - Battery

struct BatterySettingsTab: View {
    @AppStorage("warnOnLowBattery") private var warnLow = true
    @AppStorage("lowBatteryThreshold") private var threshold = 20
    @AppStorage("playSoundOnLowBattery") private var playSound = true
    @AppStorage("hidePercentage") private var hidePercentage = false

    var body: some View {
        Form {
            Toggle("common.warnOnLowBattery", isOn: $warnLow)
            Stepper("common.lowBatteryThreshold: \(threshold)%", value: $threshold, in: 5...50, step: 5)
            Toggle("common.playSoundOnLowBattery", isOn: $playSound)
            Toggle("settings.battery.hidePercentage", isOn: $hidePercentage)
        }
        .padding()
    }
}

// MARK: - Focus

struct FocusSettingsTab: View {
    @AppStorage("focusSoundEnabled") private var soundEnabled = true
    @AppStorage("soundOnSleepFocus") private var sleepSound = true

    var body: some View {
        Form {
            Toggle("common.sound", isOn: $soundEnabled)
            Toggle("settings.focus.playSoundOnSleepFocus", isOn: $sleepSound)
        }
        .padding()
    }
}

// MARK: - License

struct LicenseSettingsTab: View {
    @StateObject private var viewModel = LicenseViewModel()

    var body: some View {
        VStack(spacing: 12) {
            switch viewModel.status {
            case .licensed:
                Label("license.success.description", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            case .trial(let hours):
                Label("common.trial: \(hours)h", systemImage: "clock")
            case .expired:
                Label("common.expired", systemImage: "xmark.seal.fill")
                    .foregroundStyle(.red)
            case .unlicensed:
                LicenseView(viewModel: viewModel)
            }
        }
        .padding()
        .onAppear { viewModel.checkStatus() }
    }
}

// MARK: - About

struct AboutSettingsTab: View {
    @State private var updateState: UpdateService.UpdateState = .idle
    @State private var isChecking = false

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("ZenSpace")
                .font(.title2)
                .fontWeight(.semibold)
            Text("common.version")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            updateSection
        }
        .padding()
    }

    @ViewBuilder
    private var updateSection: some View {
        switch updateState {
        case .idle:
            Button("settings.about.checkUpdates") { checkForUpdate() }
                .buttonStyle(.bordered)
                .disabled(isChecking)
        case .checking:
            ProgressView()
                .controlSize(.small)
            Text("common.waiting")
                .font(.caption)
        case .available(let release):
            Text("v\(release.version) available")
                .font(.caption)
                .foregroundStyle(.green)
            Button("common.updateNow") { install(release: release) }
                .buttonStyle(.borderedProminent)
        case .upToDate:
            Label("Up to date", systemImage: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.green)
        case .downloading(let progress):
            ProgressView(value: progress)
                .frame(width: 150)
        case .installing:
            Text("Installing...")
                .font(.caption)
        case .error(let msg):
            Text(msg)
                .font(.caption)
                .foregroundStyle(.red)
            Button("settings.about.checkUpdates") { checkForUpdate() }
                .buttonStyle(.bordered)
        }
    }

    private func checkForUpdate() {
        isChecking = true
        updateState = .checking
        Task {
            updateState = await UpdateService.shared.checkForUpdate()
            isChecking = false
        }
    }

    private func install(release: UpdateService.Release) {
        updateState = .downloading(0)
        Task {
            updateState = await UpdateService.shared.downloadAndInstall(release: release)
        }
    }
}
