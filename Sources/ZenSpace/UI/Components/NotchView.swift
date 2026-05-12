import SwiftUI
import AppKit

struct NotchView<Content: View>: View {
    @State private var isExpanded = false
    @State private var isHovering = false
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 16 : 12))
            .glassEffect(material: .popover)
            .scaleEffect(isHovering ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
            .animation(.easeInOut(duration: 0.15), value: isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
            .onTapGesture {
                withAnimation { isExpanded.toggle() }
            }
    }
}

// MARK: - NotchWindow controller for positioning at screen notch

final class NotchWindowController {
    private var window: NSWindow?

    func show(with view: some View) {
        guard let screen = NSScreen.main else { return }
        let notchWidth: CGFloat = 300
        let notchHeight: CGFloat = 400

        let x = screen.frame.midX - notchWidth / 2
        let y = screen.frame.maxY - notchHeight - 4

        let hostingView = NSHostingView(rootView: view)
        let window = NSWindow(
            contentRect: NSRect(x: x, y: y, width: notchWidth, height: notchHeight),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.contentView = hostingView
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.hasShadow = true
        window.orderFrontRegardless()

        self.window = window
    }

    func dismiss() {
        window?.close()
        window = nil
    }
}
