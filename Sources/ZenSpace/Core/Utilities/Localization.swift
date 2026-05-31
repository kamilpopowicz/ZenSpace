import Foundation
import SwiftUI

private let strings: [String: String] = {
    let bundleName = "ZenSpace_ZenSpace.bundle"
    var bundlePath: String?

    if let execURL = Bundle.main.executableURL {
        let appRoot = execURL.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let path = appRoot.appendingPathComponent(bundleName).path
        if FileManager.default.fileExists(atPath: path) {
            bundlePath = path
        }
    }
    if bundlePath == nil {
        bundlePath = Bundle.main.bundleURL.appendingPathComponent(bundleName).path
    }

    guard let path = bundlePath else { return [:] }

    // Check user override, fallback to system
    let override = UserDefaults.standard.string(forKey: "appLanguage")
    let lang: String
    if let override, override != "system" {
        lang = override
    } else {
        let preferredLang = Locale.preferredLanguages.first?.prefix(2) ?? "en"
        lang = (preferredLang == "pl") ? "pl" : "en"
    }

    let stringsFile = "\(path)/\(lang).lproj/Localizable.strings"
    guard let data = FileManager.default.contents(atPath: stringsFile),
          let content = String(data: data, encoding: .utf8) else { return [:] }

    var result: [String: String] = [:]
    let lines = content.components(separatedBy: .newlines)
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        guard trimmed.hasPrefix("\""), trimmed.hasSuffix(";") else { continue }
        let parts = trimmed.components(separatedBy: "\" = \"")
        guard parts.count == 2 else { continue }
        let key = String(parts[0].dropFirst())
        let value = String(parts[1].dropLast(2))
        result[key] = value
    }
    return result
}()

func L(_ key: String) -> String {
    strings[key] ?? key
}
