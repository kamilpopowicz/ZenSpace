import Foundation
import AppKit
import CryptoKit

final class UpdateService {
    static let shared = UpdateService()

    private let currentVersion = AppConstants.APP_VERSION
    private let allowedURLPrefix = "https://github.com/\(AppConstants.REPO)/"

    struct Release: Decodable {
        let tagName: String
        let assets: [Asset]

        struct Asset: Decodable {
            let name: String
            let browserDownloadUrl: String

            enum CodingKeys: String, CodingKey {
                case name
                case browserDownloadUrl = "browser_download_url"
            }
        }

        enum CodingKeys: String, CodingKey {
            case tagName = "tag_name"
            case assets
        }

        var version: String {
            tagName.hasPrefix("v") ? String(tagName.dropFirst()) : tagName
        }
    }

    enum UpdateState {
        case idle
        case checking
        case available(Release)
        case downloading(Double)
        case installing
        case upToDate
        case error(String)
    }

    func checkForUpdate() async -> UpdateState {
        let url = URL(string: "https://api.github.com/repos/\(AppConstants.REPO)/releases/latest")!
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return .error("Failed to check for updates")
            }
            let release = try JSONDecoder().decode(Release.self, from: data)

            if isNewer(release.version, than: currentVersion) {
                return .available(release)
            }
            return .upToDate
        } catch {
            return .error(error.localizedDescription)
        }
    }

    func downloadAndInstall(release: Release) async -> UpdateState {
        guard let zipAsset = release.assets.first(where: { $0.name.hasSuffix(".zip") }) else {
            return .error("No zip asset found in release")
        }

        // URL pinning — only accept downloads from our repo
        guard zipAsset.browserDownloadUrl.hasPrefix(allowedURLPrefix) else {
            return .error("Download URL rejected: untrusted source")
        }

        guard let zipURL = URL(string: zipAsset.browserDownloadUrl) else {
            return .error("Invalid download URL")
        }

        // Check for SHA256 checksum asset
        let checksumAsset = release.assets.first(where: { $0.name.hasSuffix(".sha256") })

        do {
            // Download zip
            let (tempZip, _) = try await URLSession.shared.download(from: zipURL)

            // Verify checksum if available
            if let checksumAsset, let checksumURL = URL(string: checksumAsset.browserDownloadUrl) {
                let (checksumData, _) = try await URLSession.shared.data(from: checksumURL)
                let expectedHash = String(data: checksumData, encoding: .utf8)?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: " ").first ?? ""

                let fileData = try Data(contentsOf: tempZip)
                let actualHash = SHA256.hash(data: fileData).map { String(format: "%02x", $0) }.joined()

                guard actualHash == expectedHash else {
                    try? FileManager.default.removeItem(at: tempZip)
                    return .error("Checksum verification failed")
                }
            }

            // Get app location
            let appPath = Bundle.main.bundlePath
            let appURL = URL(fileURLWithPath: appPath)
            let parentDir = appURL.deletingLastPathComponent()
            let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

            // Unzip
            try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
            let unzip = Process()
            unzip.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
            unzip.arguments = ["-o", tempZip.path, "-d", tempDir.path]
            try unzip.run()
            unzip.waitUntilExit()

            guard unzip.terminationStatus == 0 else {
                try? FileManager.default.removeItem(at: tempDir)
                return .error("Failed to unzip update")
            }

            // Find .app in unzipped contents
            let contents = try FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)
            guard let newApp = contents.first(where: { $0.pathExtension == "app" }) else {
                try? FileManager.default.removeItem(at: tempDir)
                return .error("No .app found in update")
            }

            // Replace with rollback support
            let backupURL = parentDir.appendingPathComponent("ZenSpace_backup.app")
            try? FileManager.default.removeItem(at: backupURL)
            try FileManager.default.moveItem(at: appURL, to: backupURL)

            do {
                try FileManager.default.moveItem(at: newApp, to: appURL)
                // Success — remove backup
                try? FileManager.default.removeItem(at: backupURL)
            } catch {
                // Rollback — restore backup
                try? FileManager.default.moveItem(at: backupURL, to: appURL)
                try? FileManager.default.removeItem(at: tempDir)
                return .error("Install failed, rolled back: \(error.localizedDescription)")
            }

            // Cleanup
            try? FileManager.default.removeItem(at: tempDir)
            try? FileManager.default.removeItem(at: tempZip)

            // Restart
            restart()
            return .installing

        } catch {
            return .error(error.localizedDescription)
        }
    }

    private func restart() {
        let appPath = Bundle.main.bundlePath
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/sh")
        task.arguments = ["-c", "sleep 1 && open \"\(appPath)\""]
        try? task.run()
        NSApp.terminate(nil)
    }

    private func isNewer(_ remote: String, than local: String) -> Bool {
        let r = remote.split(separator: ".").compactMap { Int($0) }
        let l = local.split(separator: ".").compactMap { Int($0) }
        for i in 0..<max(r.count, l.count) {
            let rv = i < r.count ? r[i] : 0
            let lv = i < l.count ? l[i] : 0
            if rv > lv { return true }
            if rv < lv { return false }
        }
        return false
    }
}
