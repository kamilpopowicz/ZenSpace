import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsTab()
                .tabItem { Label(L("settings.tab.general"), systemImage: "gear") }

            CalendarSettingsTab()
                .tabItem { Label(L("common.calendar"), systemImage: "calendar") }

            NowPlayingSettingsTab()
                .tabItem { Label(L("common.nowPlaying"), systemImage: "music.note") }

            BatterySettingsTab()
                .tabItem { Label(L("common.battery"), systemImage: "battery.100") }

            FocusSettingsTab()
                .tabItem { Label(L("common.focus"), systemImage: "moon.fill") }

            LicenseSettingsTab()
                .tabItem { Label(L("settings.tab.license"), systemImage: "key.fill") }

            AboutSettingsTab()
                .tabItem { Label(L("settings.tab.about"), systemImage: "info.circle") }
        }
        .frame(minWidth: 550, minHeight: 400)
        .onAppear {
            NSApp.activate(ignoringOtherApps: true)
            // Bring settings window to front
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NSApp.windows.first { $0.isVisible && $0.title.contains("Settings") || $0.title.contains("Preferences") }?.makeKeyAndOrderFront(nil)
                    ?? NSApp.keyWindow?.makeKeyAndOrderFront(nil)
            }
        }
    }
}

// MARK: - General

struct GeneralSettingsTab: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false

    var body: some View {
        Form {
            Section {
                Toggle(L("settings.general.launchAtLogin"), isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _ in
                        LaunchAtLoginService.setEnabled(launchAtLogin)
                    }
            }

            Section {
                Text(L("settings.general.comingSoon"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()

                Toggle(L("settings.general.behaviour.expandOnHover"), isOn: .constant(false))
                    .disabled(true)
                Toggle(L("settings.general.behaviour.haptics"), isOn: .constant(false))
                    .disabled(true)
                Toggle(L("settings.general.behaviour.progressiveBlur"), isOn: .constant(false))
                    .disabled(true)
            }
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
            Toggle(L("settings.calendar.enableCalendar"), isOn: $calendarEnabled)
            Toggle(L("settings.calendar.playHourlyChime"), isOn: $chimeEnabled)
            Toggle(L("settings.calendar.playSoundOnEvent"), isOn: $soundOnEvent)
            Toggle(L("settings.calendar.notifyWhenTimeToLeave"), isOn: $timeToLeave)
            Toggle(L("settings.calendar.showWeatherOnEmptyDay"), isOn: $showWeather)
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
            Toggle(L("common.nowPlaying"), isOn: $enabled)
            Toggle(L("common.quickPeek"), isOn: $quickPeek)
            Toggle(L("settings.nowPlaying.hideWhileSourceAppIsActive"), isOn: $hideWhileActive)
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
            Toggle(L("common.warnOnLowBattery"), isOn: $warnLow)
            Stepper("\(L("common.lowBatteryThreshold")): \(threshold)%", value: $threshold, in: 5...50, step: 5)
            Toggle(L("common.playSoundOnLowBattery"), isOn: $playSound)
            Toggle(L("settings.battery.hidePercentage"), isOn: $hidePercentage)
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
            Toggle(L("common.sound"), isOn: $soundEnabled)
            Toggle(L("settings.focus.playSoundOnSleepFocus"), isOn: $sleepSound)
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
                Label(L("license.success.description"), systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            case .trial(let hours):
                Label("\(L("common.trial")): \(hours)h", systemImage: "clock")
            case .expired:
                Label(L("common.expired"), systemImage: "xmark.seal.fill")
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
            Text("v\(AppConstants.APP_VERSION)")
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
            Button(L("settings.about.checkUpdates")) { checkForUpdate() }
                .buttonStyle(.bordered)
                .disabled(isChecking)
        case .checking:
            ProgressView()
                .controlSize(.small)
            Text(L("common.waiting"))
                .font(.caption)
        case .available(let release):
            Text("v\(release.version) \(L("update.versionAvailable"))")
                .font(.caption)
                .foregroundStyle(.green)
            Button(L("common.updateNow")) { install(release: release) }
                .buttonStyle(.borderedProminent)
        case .upToDate:
            Label(L("update.upToDate"), systemImage: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.green)
        case .downloading(let progress):
            ProgressView(value: progress)
                .frame(width: 150)
        case .installing:
            Text(L("update.installing"))
                .font(.caption)
        case .error(let msg):
            Text(msg)
                .font(.caption)
                .foregroundStyle(.red)
            Button(L("settings.about.checkUpdates")) { checkForUpdate() }
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
