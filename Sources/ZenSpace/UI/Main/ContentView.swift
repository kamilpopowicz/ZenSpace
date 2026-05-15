import SwiftUI
import AppKit

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title3)
                Text("ZenSpace")
                    .font(.headline)
                Spacer()
                Text("v\(AppConstants.APP_VERSION)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 4)

            Divider()

            CalendarView()

            Divider()

            NowPlayingView()

            Divider()

            FocusView()

            Divider()

            BatteryView()

            Divider()

            DisplayView()

            Divider()

            HStack(spacing: 12) {
                if #available(macOS 14.0, *) {
                    SettingsLink {
                        Label(L("menu.settings"), systemImage: "gear")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                } else {
                    Button {
                        // Dismiss the menu bar popup
                        NSApp.keyWindow?.close()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            NSApp.activate(ignoringOtherApps: true)
                            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                        }
                    } label: {
                        Label(L("menu.settings"), systemImage: "gear")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }

                Spacer()

                Button {
                    NSApp.terminate(nil)
                } label: {
                    Label(String(format: L("menu.quit"), AppConstants.APP_NAME), systemImage: "power")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding(16)
        .frame(width: 300, alignment: .top)
    }
}
