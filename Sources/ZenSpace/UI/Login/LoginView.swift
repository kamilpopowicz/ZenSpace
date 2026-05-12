import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LicenseViewModel()

    var body: some View {
        Group {
            switch viewModel.status {
            case .licensed:
                ContentView()
            case .trial:
                ContentView()
            case .expired:
                LicenseView(viewModel: viewModel)
            case .unlicensed:
                LicenseView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.checkStatus()
        }
    }
}
