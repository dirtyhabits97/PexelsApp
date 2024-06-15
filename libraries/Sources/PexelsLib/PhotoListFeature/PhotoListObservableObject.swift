import Combine
import SwiftUI

// TODO: Move this to its own PexelsFeature package

@available(macOS 15.0, *)
final class PhotoListObservableObject: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    @Published
    var photos: [Photo] = []

    private let imagesService: ImagesService
    private var lastResponse: GetCuratedImagesResponse?

    init(imagesService: ImagesService) {
        self.imagesService = imagesService
    }

    func loadMorePhotos() {
        let nextPage = (lastResponse?.page ?? 0) + 1
        let request = GetCuratedImagesRequest(page: nextPage)

        imagesService
            .getCuratedImages(request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("com.PhotoListObservableObject: Failed to load more photos. Request: \(request). Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.lastResponse = response
                self?.photos.append(contentsOf: response.photos)
            })
            .store(in: &cancellables)
    }
}
