import Foundation

/// Protocol defining the XPC service interface for ZenSpace Helper
@objc protocol ZenSpaceHelperProtocol {
    /// Get current now playing metadata
    func getNowPlayingInfo(reply: @escaping (Data?) -> Void)

    /// Send media command (play/pause/next/previous)
    func sendMediaCommand(_ command: Int, reply: @escaping (Bool) -> Void)

    /// Check if BetterDisplay is running
    func isBetterDisplayRunning(reply: @escaping (Bool) -> Void)

    /// Get battery level
    func getBatteryLevel(reply: @escaping (Int, Bool) -> Void)
}

/// Protocol for the main app to receive callbacks from helper
@objc protocol ZenSpaceAppProtocol {
    /// Notify app of now playing changes
    func nowPlayingDidChange(_ data: Data?)

    /// Notify app of BetterDisplay state change
    func betterDisplayStateChanged(_ isRunning: Bool)
}

// MARK: - XPC Service identifiers

enum XPCConstants {
    static let serviceName = "com.zenspace.helper"
    static let machServiceName = "com.zenspace.helper.mach"
}
