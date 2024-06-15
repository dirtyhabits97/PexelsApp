import Combine
@testable import PexelsLib
import XCTest

@available(iOS 16.0, *)
@available(macOS 15.0, *)
final class PhotoListObservableObjectTests: XCTestCase {
    func test_receivesEmptyPhotos() throws {
        // given
        let httpClient = HTTPClientMock()
        let imagesService = ImagesService(httpClient: httpClient)
        let observableObject = PhotoListObservableObject(imagesService: imagesService)
        XCTAssertEqual(httpClient.enqueueCallCount, 0)
        XCTAssertEqual(observableObject.photos.count, 0)
        // when
        httpClient.enqueueHandler = { _ in
            let response = GetCuratedImagesResponse(page: 1, perPage: 1, photos: [], nextPage: nil)
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        observableObject.loadMorePhotos()
        observableObject.loadMorePhotos()
        // then
        XCTAssertEqual(httpClient.enqueueCallCount, 2)
        XCTAssertEqual(observableObject.photos.count, 0)
    }

    func test_photosGetUpdated() throws {
        // given
        let httpClient = HTTPClientMock()
        let imagesService = ImagesService(httpClient: httpClient)
        let observableObject = PhotoListObservableObject(imagesService: imagesService)
        let photo1 = Photo(
            id: 1, width: 0, height: 0, url: .dummy,
            photographer: "", photographerURL: .dummy, photographerId: 0,
            avgColor: "", src: PhotoSource(tiny: .dummy), alt: ""
        )
        let page1 = GetCuratedImagesResponse(page: 1, perPage: 1, photos: [photo1], nextPage: nil)
        let photo2 = Photo(
            id: 2, width: 0, height: 0, url: .dummy,
            photographer: "", photographerURL: .dummy, photographerId: 0,
            avgColor: "", src: PhotoSource(tiny: .dummy), alt: ""
        )
        let page2 = GetCuratedImagesResponse(page: 2, perPage: 1, photos: [photo2], nextPage: nil)
        XCTAssertEqual(observableObject.photos.count, 0)
        // when
        var isFirstTime = true
        httpClient.enqueueHandler = { _ in
            let response = isFirstTime ? page1 : page2
            isFirstTime = false
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        // then
        observableObject.loadMorePhotos()
        XCTAssertEqual(observableObject.photos.count, 1)
        XCTAssertEqual(observableObject.photos[0].id, photo1.id)
        // then
        observableObject.loadMorePhotos()
        XCTAssertEqual(observableObject.photos.count, 2)
        XCTAssertEqual(observableObject.photos[1].id, photo2.id)
    }
}

extension URL {
    static let dummy = URL(string: "https://dummy.url")!
}
