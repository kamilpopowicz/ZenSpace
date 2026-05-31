import SwiftUI

struct SettingsView: View {
    @State private var selectedTab = "general"

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Label(L("settings.tab.general"), systemImage: "gear").tag("general")
                Label(L("common.calendar"), systemImage: "calendar").tag("calendar")
                Label(L("common.nowPlaying"), systemImage: "music.note").tag("nowplaying")
                Label(L("common.battery"), systemImage: "battery.100").tag("battery")
                Label(L("common.focus"), systemImage: "moon.fill").tag("focus")
                Label(L("settings.tab.license"), systemImage: "key.fill").tag("license")
                Label(L("settings.tab.about"), systemImage: "info.circle").tag("about")
            }
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            switch selectedTab {
            case "general": GeneralSettingsTab()
            case "calendar": CalendarSettingsTab()
            case "nowplaying": NowPlayingSettingsTab()
            case "battery": BatterySettingsTab()
            case "focus": FocusSettingsTab()
            case "license": LicenseSettingsTab()
            case "about": AboutSettingsTab()
            default: GeneralSettingsTab()
            }
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            NSApp.activate(ignoringOtherApps: true)
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

            Section("Language") {
                Picker("Language", selection: Binding(
                    get: { UserDefaults.standard.string(forKey: "appLanguage") ?? "system" },
                    set: { newValue in
                        UserDefaults.standard.set(newValue, forKey: "appLanguage")
                        // Restart app to apply
                        let url = URL(fileURLWithPath: Bundle.main.bundlePath)
                        NSWorkspace.shared.openApplication(at: url, configuration: .init())
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            NSApp.terminate(nil)
                        }
                    }
                )) {
                    Text("System").tag("system")
                    Text("🇬🇧 English").tag("en")
                    Text("🇵🇱 Polski").tag("pl")
                }
                Text("App restarts on language change.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
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

    var body: some View {
        Form {
            Section {
                Toggle(L("settings.calendar.enableCalendar"), isOn: $calendarEnabled)
            }

            Section {
                Text(L("settings.general.comingSoon"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()

                Toggle(L("settings.calendar.playHourlyChime"), isOn: .constant(false))
                    .disabled(true)
                Toggle(L("settings.calendar.playSoundOnEvent"), isOn: .constant(false))
                    .disabled(true)
                Toggle(L("settings.calendar.notifyWhenTimeToLeave"), isOn: .constant(false))
                    .disabled(true)
                Toggle(L("settings.calendar.showWeatherOnEmptyDay"), isOn: .constant(false))
                    .disabled(true)
            }
        }
        .padding()
    }
}

// MARK: - Now Playing

struct NowPlayingSettingsTab: View {
    @AppStorage("nowPlayingEnabled") private var enabled = true

    var body: some View {
        Form {
            Section {
                Toggle(L("common.nowPlaying"), isOn: $enabled)
            }

            Section {
                Text(L("settings.general.comingSoon"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()

                Toggle(L("common.quickPeek"), isOn: .constant(false))
                    .disabled(true)
                Toggle(L("settings.nowPlaying.hideWhileSourceAppIsActive"), isOn: .constant(false))
                    .disabled(true)
            }
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
    var body: some View {
        Form {
            Text(L("settings.general.comingSoon"))
                .font(.caption)
                .foregroundStyle(.secondary)
                .italic()

            Toggle(L("common.sound"), isOn: .constant(false))
                .disabled(true)
            Toggle(L("settings.focus.playSoundOnSleepFocus"), isOn: .constant(false))
                .disabled(true)
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
