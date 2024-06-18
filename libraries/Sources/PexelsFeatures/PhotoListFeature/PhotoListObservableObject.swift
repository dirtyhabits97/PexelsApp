import Combine
import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
public final class PhotoListObservableObject: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    @Published
    var photos: [Photo] = []

    private let imagesService: ImagesService
    private var lastResponse: GetCuratedImagesResponse?
    private let localStorage: (any LocalStorage)?

    public init(
        imagesService: ImagesService,
        localStorage: (any LocalStorage)? = nil
    ) {
        self.imagesService = imagesService
        self.localStorage = localStorage

        if let localStorage {
            localStorage
                .loadFromDisk(Photo.self)
                .prefix(1)
                .assign(to: \.photos, on: self)
                .store(in: &cancellables)
        }
    }

    func loadMorePhotos() {
        let nextPage = (lastResponse?.page ?? 0) + 1
        let request = GetCuratedImagesRequest(page: nextPage)

        imagesService
            .getCuratedImages(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("com.PhotoListObservableObject: Failed to load more photos. Request: \(request). Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.updateLocalStorage(with: response)
                // If this is the first page, update the current objects in memory
                if response.page == 1 {
                    self?.photos = response.photos
                // Else, add objects to the array
                } else {
                    self?.photos.append(contentsOf: response.photos)
                    
                }
                self?.lastResponse = response
            })
            .store(in: &cancellables)
    }

    // WARN: Because we are using pagination, only store the results from the first page
    // This is what we will serve in the offline mode. Supporting more pages requires
    // keeping track of state and that is out of scope
    private func updateLocalStorage(with response: GetCuratedImagesResponse) {
        guard response.page == 1 else { return }
        do {
            try localStorage?.clearFromDisk(Photo.self)
            try localStorage?.saveToDisk(response.photos)
            print("com.PhotoListObservableObject: Updating local storage")
        } catch {
            print("com.PhotoListObservableObject: \(#function) Error \(error)")
        }
    }
}
