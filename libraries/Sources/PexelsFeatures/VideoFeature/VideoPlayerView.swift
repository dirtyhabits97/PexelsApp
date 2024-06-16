import AVKit
import SwiftUI

@available(macOS 15.0, *)
struct VideoPlayerView: View {
    let videoURL: URL

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .onAppear {
                // Automatically start playing the video when the view appears
                let player = AVPlayer(url: videoURL)
                player.play()
            }
            .frame(height: 300) // Adjust the frame height as needed
            .cornerRadius(10)
            .padding()
    }
}
