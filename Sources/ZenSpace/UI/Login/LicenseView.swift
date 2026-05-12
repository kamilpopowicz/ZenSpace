import SwiftUI

struct LicenseView: View {
    @ObservedObject var viewModel: LicenseViewModel

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "key.fill")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)

            Text("license.title.activate")
                .font(.headline)

            TextField("license.placeholder.key", text: $viewModel.licenseKey)
                .textFieldStyle(.roundedBorder)

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Button("license.action.activateLicense") {
                viewModel.activate()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.licenseKey.isEmpty || viewModel.isActivating)

            Divider()

            Button("license.action.startTrial") {
                viewModel.startTrial()
            }
            .buttonStyle(.bordered)

            Text("license.help.trialLimit")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(width: 300)
    }
}
