import SwiftUI

struct NowPlayingView: View {
    @StateObject private var viewModel = MediaViewModel()
    @AppStorage("nowPlayingEnabled") private var enabled = true

    var body: some View {
        if enabled {
            VStack(spacing: 10) {
                if viewModel.hasMedia {
                    mediaInfoView
                    controlsView
                } else {
                    emptyView
                }
            }
            .onAppear { viewModel.start() }
        }
    }

    private var mediaInfoView: some View {
        HStack(spacing: 10) {
            artworkView

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)

                if !viewModel.artist.isEmpty {
                    Text(viewModel.artist)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
    }

    private var artworkView: some View {
        Group {
            if let data = viewModel.metadata?.albumArtwork,
               let nsImage = NSImage(data: data) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "music.note")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 36, height: 36)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private var controlsView: some View {
        HStack(spacing: 20) {
            Button { viewModel.previous() } label: {
                Image(systemName: "backward.fill")
                    .font(.caption)
            }
            .buttonStyle(.plain)

            Button { viewModel.togglePlayPause() } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.body)
            }
            .buttonStyle(.plain)

            Button { viewModel.next() } label: {
                Image(systemName: "forward.fill")
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
    }

    private var emptyView: some View {
        HStack(spacing: 8) {
            Image(systemName: "music.note")
                .foregroundStyle(.secondary)
            Text(L("media.notPlaying"))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
