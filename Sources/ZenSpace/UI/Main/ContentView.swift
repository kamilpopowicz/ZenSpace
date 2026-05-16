import SwiftUI
import AppKit

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) private var openWindow

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
                Button {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        NSApp.activate(ignoringOtherApps: true)
                        openWindow(id: "settings")
                    }
                } label: {
                    Label(L("menu.settings"), systemImage: "gear")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

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
