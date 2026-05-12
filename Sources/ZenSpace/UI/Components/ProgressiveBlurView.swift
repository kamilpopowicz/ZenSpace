import SwiftUI
import AppKit

struct ProgressiveBlurView: View {
    var direction: Direction = .topToBottom
    var steps: Int = 6
    var maxRadius: CGFloat = 20

    enum Direction {
        case topToBottom, bottomToTop
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                let orderedSteps = direction == .topToBottom
                    ? Array(0..<steps)
                    : Array((0..<steps).reversed())

                ForEach(orderedSteps, id: \.self) { step in
                    let fraction = CGFloat(step) / CGFloat(steps - 1)
                    let radius = maxRadius * fraction
                    Rectangle()
                        .fill(.clear)
                        .frame(height: geo.size.height / CGFloat(steps))
                        .blur(radius: radius)
                        .background(
                            GlassEffectView(material: .hudWindow, blendingMode: .behindWindow)
                                .opacity(Double(fraction))
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

extension View {
    func progressiveBlur(
        direction: ProgressiveBlurView.Direction = .bottomToTop,
        maxRadius: CGFloat = 20
    ) -> some View {
        overlay(alignment: direction == .bottomToTop ? .bottom : .top) {
            ProgressiveBlurView(direction: direction, maxRadius: maxRadius)
                .frame(height: 40)
        }
    }
}
