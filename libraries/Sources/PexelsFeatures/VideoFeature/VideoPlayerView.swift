import AVKit
import SwiftUI

// WARN: I was hitting the following error:
// Main thread blocked by synchronous property query on not-yet-loaded property (PreferredTransform) for HTTP(S) asset. This could have been a problem if this asset were being read from a slow network.
//
// Solved by: https://forums.developer.apple.com/forums/thread/749501
@available(macOS 15.0, *)
struct VideoPlayerView: View {
    let videoURL: URL

    @State
    private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .task {
                player = AVPlayer(url: videoURL)
            }
            .frame(height: 300) // Adjust the frame height as needed
            .cornerRadius(10)
            .padding()
    }
}
