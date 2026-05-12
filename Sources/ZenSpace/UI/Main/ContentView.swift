import SwiftUI

struct ContentView: View {
    var body: some View {
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
        }
        .padding(16)
        .frame(width: 300)
    }
}
