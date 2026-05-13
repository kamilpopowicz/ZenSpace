import SwiftUI
import AppKit

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.title3)
                    Text("ZenSpace")
                        .font(.headline)
                    Spacer()
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
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    } label: {
                        Label("menu.settings", systemImage: "gear")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)

                    Spacer()

                    Button {
                        NSApp.terminate(nil)
                    } label: {
                        Label("menu.quit", systemImage: "power")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            .padding(16)
        }
        .frame(width: 300)
        .frame(maxHeight: 500)
        .glassEffect(material: .hudWindow)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
