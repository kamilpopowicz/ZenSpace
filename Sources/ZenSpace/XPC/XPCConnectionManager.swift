import Foundation

final class XPCConnectionManager: NSObject {
    static let shared = XPCConnectionManager()

    private var connection: NSXPCConnection?
    private var isConnected = false
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5

    private override init() {
        super.init()
    }

    func connect() {
        guard connection == nil else { return }

        let conn = NSXPCConnection(serviceName: XPCConstants.serviceName)
        conn.remoteObjectInterface = NSXPCInterface(with: ZenSpaceHelperProtocol.self)
        conn.exportedInterface = NSXPCInterface(with: ZenSpaceAppProtocol.self)
        conn.exportedObject = self

        conn.invalidationHandler = { [weak self] in
            self?.connection = nil
            self?.isConnected = false
        }

        conn.interruptionHandler = { [weak self] in
            self?.isConnected = false
            guard let self, self.reconnectAttempts < self.maxReconnectAttempts else { return }
            self.reconnectAttempts += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.reconnectAttempts)) {
                self.connect()
            }
        }

        conn.resume()
        connection = conn
        isConnected = true
        reconnectAttempts = 0
    }

    func disconnect() {
        connection?.invalidate()
        connection = nil
        isConnected = false
    }

    var helper: ZenSpaceHelperProtocol? {
        connection?.remoteObjectProxyWithErrorHandler { error in
            print("[XPC] Remote proxy error: \(error.localizedDescription)")
        } as? ZenSpaceHelperProtocol
    }

    // MARK: - Convenience methods

    func getNowPlayingInfo(completion: @escaping (Data?) -> Void) {
        guard let helper else { completion(nil); return }
        helper.getNowPlayingInfo(reply: completion)
    }

    func sendMediaCommand(_ command: Int, completion: @escaping (Bool) -> Void) {
        guard let helper else { completion(false); return }
        helper.sendMediaCommand(command, reply: completion)
    }

    func checkBetterDisplay(completion: @escaping (Bool) -> Void) {
        guard let helper else { completion(false); return }
        helper.isBetterDisplayRunning(reply: completion)
    }

    func getBatteryLevel(completion: @escaping (Int, Bool) -> Void) {
        guard let helper else { completion(0, false); return }
        helper.getBatteryLevel(reply: completion)
    }
}

// MARK: - ZenSpaceAppProtocol conformance

extension XPCConnectionManager: ZenSpaceAppProtocol {
    func nowPlayingDidChange(_ data: Data?) {
        NotificationCenter.default.post(name: MediaService.nowPlayingChanged, object: data)
    }

    func betterDisplayStateChanged(_ isRunning: Bool) {
        NotificationCenter.default.post(
            name: DisplayService.displayChanged,
            object: isRunning ? NotificationType.launched : NotificationType.terminated
        )
    }
}
