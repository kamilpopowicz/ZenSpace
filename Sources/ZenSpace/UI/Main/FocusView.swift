import SwiftUI

struct FocusView: View {
    @StateObject private var viewModel = FocusViewModel()

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: viewModel.modeIcon)
                .font(.caption)
                .foregroundStyle(viewModel.isActive ? .primary : .secondary)

            Text(viewModel.modeName)
                .font(.caption)
                .foregroundStyle(viewModel.isActive ? .primary : .secondary)

            Spacer()

            if viewModel.isActive {
                Circle()
                    .fill(.green)
                    .frame(width: 6, height: 6)
            }
        }
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
    }
}
