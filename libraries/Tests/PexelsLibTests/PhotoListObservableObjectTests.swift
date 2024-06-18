import Combine
@testable import PexelsFeatures
@testable import PexelsLib
import XCTest

@available(macOS 15.0, *)
final class PhotoListObservableObjectTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var httpClient = HTTPClientMock()
    var imagesService = ImagesService(httpClient: HTTPClientMock())

    func test_receivesEmptyPhotos() throws {
        // given
        let expectation = expectation(description: #function)
        let observableObject = PhotoListObservableObject(imagesService: imagesService)
        let fixture = try getFixture("curated_photos_empty_photos.json", as: GetCuratedImagesResponse.self)

        XCTAssertEqual(httpClient.enqueueCallCount, 0)
        XCTAssertEqual(observableObject.photos.count, 0)
        // when
        httpClient.enqueueHandler = { _ in
            Just(fixture)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        observableObject.$photos
            .dropFirst()
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)

        observableObject.loadMorePhotos()

        wait(for: [expectation], timeout: 1)
        // then
        XCTAssertEqual(httpClient.enqueueCallCount, 1)
        XCTAssertEqual(observableObject.photos.count, 0)
    }

    func test_photosGetUpdated() throws {
        // given
        let expectation = expectation(description: #function)
        let observableObject = PhotoListObservableObject(imagesService: imagesService)
        let page1 = try getFixture("curated_photos_page_1.json", as: GetCuratedImagesResponse.self)
        let page2 = try getFixture("curated_photos_page_2.json", as: GetCuratedImagesResponse.self)

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

        observableObject.$photos
            .dropFirst()
            .sink(receiveValue: { photos in
                if photos.count == 2 {
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)

        observableObject.loadMorePhotos()
        observableObject.loadMorePhotos()

        wait(for: [expectation], timeout: 1)
        // then
        XCTAssertEqual(observableObject.photos.count, 2)
        XCTAssertEqual(observableObject.photos[0].id, page1.photos.first?.id)
        XCTAssertEqual(observableObject.photos[1].id, page2.photos.first?.id)
    }

    // MARK: - Helpers

    override func setUp() {
        super.setUp()
        cancellables = []
        httpClient = HTTPClientMock()
        imagesService = ImagesService(httpClient: httpClient)
    }
}
