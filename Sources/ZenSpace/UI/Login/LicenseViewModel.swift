import Foundation
import SwiftUI

@MainActor
final class LicenseViewModel: ObservableObject {
    @Published var status: LicenseStatus = .licensed
    @Published var licenseKey: String = ""
    @Published var isActivating: Bool = false
    @Published var errorMessage: String?

    private let service = LicenseService()

    func checkStatus() {
        status = service.checkStatus()
    }

    func activate() {
        guard !licenseKey.isEmpty else {
            errorMessage = "Enter a license key"
            return
        }
        isActivating = true
        errorMessage = nil

        if service.activate(key: licenseKey) {
            status = .licensed
            licenseKey = ""
        } else {
            errorMessage = "Activation failed"
        }
        isActivating = false
    }

    func startTrial() {
        service.startTrial()
        checkStatus()
    }

    func deactivate() {
        _ = service.deactivate()
        checkStatus()
    }
}
