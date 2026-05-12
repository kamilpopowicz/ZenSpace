import Foundation

enum PlaybackState: String, Codable {
    case playing
    case paused
    case stopped
    case buffering
}

struct MediaMetadata: Codable {
    let title: String
    let artist: String?
    let album: String?
    let albumArtwork: Data?
    let playbackState: PlaybackState
    let playbackPosition: TimeInterval
    let playbackSpeed: Float
    let isDolbyAtmos: Bool
}
