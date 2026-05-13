import Foundation
import AppKit

// MARK: - MediaRemote private framework bridge

private let bundle: CFBundle? = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))

private let MRMediaRemoteGetNowPlayingInfoPointer = bundle.flatMap { CFBundleGetFunctionPointerForName($0, "MRMediaRemoteGetNowPlayingInfo" as CFString) }
private let MRMediaRemoteSendCommandPointer = bundle.flatMap { CFBundleGetFunctionPointerForName($0, "MRMediaRemoteSendCommand" as CFString) }
private let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = bundle.flatMap { CFBundleGetFunctionPointerForName($0, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString) }

private typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
private typealias MRMediaRemoteSendCommandFunction = @convention(c) (UInt32, UnsafeRawPointer?) -> Void
private typealias MRMediaRemoteRegisterFunction = @convention(c) (DispatchQueue) -> Void

private enum MRCommand: UInt32 {
    case play = 0
    case pause = 1
    case togglePlayPause = 2
    case nextTrack = 4
    case previousTrack = 5
}

final class MediaService {
    static let nowPlayingChanged = Notification.Name("com.zenspace.nowPlayingChanged")

    private var isRegistered = false

    func register() {
        guard !isRegistered else { return }
        guard let pointer = MRMediaRemoteRegisterForNowPlayingNotificationsPointer else { return }
        let register = unsafeBitCast(pointer, to: MRMediaRemoteRegisterFunction.self)
        register(DispatchQueue.main)

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleNowPlayingChange),
            name: NSNotification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification"),
            object: nil
        )
        isRegistered = true
    }

    func unregister() {
        guard isRegistered else { return }
        DistributedNotificationCenter.default().removeObserver(self)
        isRegistered = false
    }

    deinit {
        unregister()
    }

    func getNowPlayingInfo(completion: @escaping (MediaMetadata?) -> Void) {
        guard let pointer = MRMediaRemoteGetNowPlayingInfoPointer else {
            completion(nil)
            return
        }
        let getInfo = unsafeBitCast(pointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)
        getInfo(DispatchQueue.main) { info in
            guard let title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String else {
                completion(nil)
                return
            }
            let metadata = MediaMetadata(
                title: title,
                artist: info["kMRMediaRemoteNowPlayingInfoArtist"] as? String,
                album: info["kMRMediaRemoteNowPlayingInfoAlbum"] as? String,
                albumArtwork: info["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data,
                playbackState: (info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double) == 1.0 ? .playing : .paused,
                playbackPosition: info["kMRMediaRemoteNowPlayingInfoElapsedTime"] as? TimeInterval ?? 0,
                playbackSpeed: Float(info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Double ?? 0),
                isDolbyAtmos: false
            )
            completion(metadata)
        }
    }

    func togglePlayPause() { sendCommand(.togglePlayPause) }
    func nextTrack() { sendCommand(.nextTrack) }
    func previousTrack() { sendCommand(.previousTrack) }

    private func sendCommand(_ command: MRCommand) {
        guard let pointer = MRMediaRemoteSendCommandPointer else { return }
        let send = unsafeBitCast(pointer, to: MRMediaRemoteSendCommandFunction.self)
        send(command.rawValue, nil)
    }

    @objc private func handleNowPlayingChange() {
        NotificationCenter.default.post(name: Self.nowPlayingChanged, object: nil)
    }
}
