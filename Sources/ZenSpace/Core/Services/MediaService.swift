import Foundation
import AppKit

// MARK: - MediaRemote private framework bridge
// Uses MRMediaRemote via dynamic loading (private API used by Alcove/other menu bar apps)

private let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))

private let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)
private let MRMediaRemoteSendCommandPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteSendCommand" as CFString)
private let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)

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

    func register() {
        guard let pointer = MRMediaRemoteRegisterForNowPlayingNotificationsPointer else { return }
        let register = unsafeBitCast(pointer, to: MRMediaRemoteRegisterFunction.self)
        register(DispatchQueue.main)

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(handleNowPlayingChange),
            name: NSNotification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification"),
            object: nil
        )
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
