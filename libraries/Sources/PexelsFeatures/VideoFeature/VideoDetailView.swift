import Combine
import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
public struct VideoDetailView: View {
    @StateObject
    private var observedObject: VideoDetailObservableObject

    public init(videoDetailObservableObject: VideoDetailObservableObject) {
        _observedObject = StateObject(wrappedValue: videoDetailObservableObject)
    }

    public var body: some View {
        contentView
            .onAppear {
                observedObject.fetchVideoMetadata()
            }
    }

    @ViewBuilder
    private var contentView: some View {
        if observedObject.isLoading {
            ProgressView("Loading...")
        } else if let errorMessage = observedObject.errorMessage {
            Text("Error: \(errorMessage)")
                .foregroundColor(.red)
        } else if let video = observedObject.video {
            VideoContentView(video: video)
        } else {
            ProgressView("Loading...")
        }
    }
}

@available(macOS 15.0, *)
private struct VideoContentView: View {
    let video: Video

    var videoURL: URL? {
        return video.videoFiles.first { $0.quality == "hd" }?.link
            ?? video.videoFiles.first?.link
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // TODO: Avoid force unwrap
            VideoPlayerView(videoURL: videoURL!)

            Text(video.user.name)
                .font(.title2)
                .fontWeight(.bold)

            Text(video.url.absoluteString)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)

            HStack(spacing: 4) {
                Text("Duration:")
                    .font(.caption)
                    .fontWeight(.bold)
                Text("\(video.duration) seconds")
                    .font(.caption)
                Spacer()
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

