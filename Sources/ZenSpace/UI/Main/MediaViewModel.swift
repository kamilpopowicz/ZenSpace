import Foundation
import SwiftUI

@MainActor
final class MediaViewModel: ObservableObject {
    @Published var metadata: MediaMetadata?
    @Published var isPlaying: Bool = false

    private let service = MediaService()

    var title: String { metadata?.title ?? String(localized: "media.notPlaying") }
    var artist: String { metadata?.artist ?? "" }
    var album: String { metadata?.album ?? "" }
    var hasMedia: Bool { metadata != nil }

    func start() {
        service.register()
        NotificationCenter.default.addObserver(
            forName: MediaService.nowPlayingChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.refresh()
            }
        }
        refresh()
    }

    func refresh() {
        service.getNowPlayingInfo { [weak self] info in
            Task { @MainActor in
                self?.metadata = info
                self?.isPlaying = info?.playbackState == .playing
            }
        }
    }

    func togglePlayPause() {
        service.togglePlayPause()
        isPlaying.toggle()
    }

    func next() {
        service.nextTrack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.refresh()
        }
    }

    func previous() {
        service.previousTrack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.refresh()
        }
    }
}
