import SwiftUI

@main
struct ZenSpaceApp: App {
    @Environment(\.openWindow) private var openWindow

    init() {
    }

    var body: some Scene {
        MenuBarExtra("ZenSpace", systemImage: "brain.head.profile") {
            LoginView()
        }
        .menuBarExtraStyle(.window)

        Window(L("menu.settings"), id: "settings") {
            SettingsView()
        }
        .defaultSize(width: 700, height: 450)
        .windowResizability(.contentMinSize)
    }
}
