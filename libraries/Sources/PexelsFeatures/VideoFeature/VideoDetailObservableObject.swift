import Combine
import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
public final class VideoDetailObservableObject: ObservableObject {
    @Published
    var video: Video?

    @Published
    var isLoading = false

    @Published
    var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let videoService: VideoService
    private let videoIds: [Int]

    public init(videoService: VideoService, videoIds: [Int]) {
        self.videoService = videoService
        self.videoIds = videoIds
    }

    func fetchVideoMetadata() {
        let request = GetVideoMetadataRequest(id: getVideoId())
        isLoading = true
        videoService
            .getVideoMetadata(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false

                switch completion {
                case let .failure(error):
                    print("com.VideoDetailObservableObject: Failed to load video. Request: \(request). Error: \(error)")
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    self?.errorMessage = nil
                }
            }, receiveValue: { [weak self] response in
                self?.video = response
            })
            .store(in: &cancellables)
    }

    private func getVideoId() -> Int {
        videoIds.randomElement() ?? -1
    }
}
