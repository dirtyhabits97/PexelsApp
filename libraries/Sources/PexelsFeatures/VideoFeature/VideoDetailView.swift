import Combine
import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
struct VideoDetailView: View {
    @StateObject
    private var observedObject: VideoDetailObservableObject

    init(videoDetailObservableObject: VideoDetailObservableObject) {
        _observedObject = StateObject(wrappedValue: videoDetailObservableObject)
    }

    var body: some View {
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
            if let videoURL {
                VideoPlayerView(videoURL: videoURL)
            } else {
                Text("Couldn't find the video file")
                    .foregroundColor(.red)
            }

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
