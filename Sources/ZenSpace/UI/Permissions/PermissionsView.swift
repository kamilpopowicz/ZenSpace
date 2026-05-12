import SwiftUI
import EventKit

struct PermissionsView: View {
    @State private var calendarStatus: EKAuthorizationStatus = .notDetermined
    @State private var accessibilityGranted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("settings.section.notifications")
                .font(.headline)

            PermissionRow(
                title: "common.calendar",
                icon: "calendar",
                granted: calendarStatus == .authorized,
                action: requestCalendar
            )

            PermissionRow(
                title: "common.nowPlaying",
                icon: "music.note",
                granted: true, // Media doesn't require explicit permission on macOS
                action: {}
            )

            PermissionRow(
                title: "Accessibility",
                icon: "accessibility",
                granted: accessibilityGranted,
                action: openAccessibility
            )

            PermissionRow(
                title: "Bluetooth",
                icon: "wave.3.right",
                granted: true, // Checked at runtime
                action: {}
            )
        }
        .padding()
        .onAppear { checkPermissions() }
    }

    private func checkPermissions() {
        calendarStatus = EKEventStore.authorizationStatus(for: .event)
        accessibilityGranted = AXIsProcessTrusted()
    }

    private func requestCalendar() {
        Task {
            let store = EKEventStore()
            if #available(macOS 14.0, *) {
                _ = try? await store.requestFullAccessToEvents()
            } else {
                _ = await withCheckedContinuation { cont in
                    store.requestAccess(to: .event) { granted, _ in cont.resume(returning: granted) }
                }
            }
            calendarStatus = EKEventStore.authorizationStatus(for: .event)
        }
    }

    private func openAccessibility() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
}

struct PermissionRow: View {
    let title: LocalizedStringKey
    let icon: String
    let granted: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
            Text(title)
                .font(.body)
            Spacer()
            if granted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else {
                Button("settings.permissions.askPermission") { action() }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
        }
    }
}
