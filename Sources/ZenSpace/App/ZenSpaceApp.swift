import SwiftUI

@main
struct ZenSpaceApp: App {
    var body: some Scene {
        MenuBarExtra("ZenSpace", systemImage: "brain.head.profile") {
            LoginView()
        }
        .menuBarExtraStyle(.window)
    }
}
