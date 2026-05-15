import SwiftUI

/// Localize string from Bundle.module (SPM resource bundle)
func L(_ key: String) -> String {
    NSLocalizedString(key, bundle: .module, comment: "")
}

/// LocalizedStringKey that resolves from Bundle.module
extension Text {
    init(localized key: String) {
        self.init(L(key))
    }
}
