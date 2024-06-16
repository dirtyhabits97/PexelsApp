import Combine
@testable import PexelsFeatures
@testable import PexelsLib
import SnapshotTesting
import XCTest

@available(macOS 15.0, *)
final class PhotoListViewTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var httpClient = HTTPClientMock()
    private var imagesService = ImagesService(httpClient: HTTPClientMock())

    func test_rowView() throws {
        // given
        let fixture = try getFixture(
            "curated_photos_page_1.json",
            as: GetCuratedImagesResponse.self
        ).photos[0]
        // then
        let view = PhotoRowView(photo: fixture)
        #if os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light))
            )
        #endif
    }

    func test_listWithOneElement() throws {
        // given
        let expectation = expectation(description: #function)
        let observableObject = PhotoListObservableObject(imagesService: imagesService)
        let fixture = try getFixture("curated_photos_page_1.json", as: GetCuratedImagesResponse.self)
        // when
        httpClient.enqueueHandler = { _ in
            Just(fixture)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        observableObject.$photos
            .dropFirst()
            .sink(receiveValue: { _ in expectation.fulfill() })
            .store(in: &cancellables)

        observableObject.loadMorePhotos()
        wait(for: [expectation], timeout: 1)

        // then
        let view = PhotoListView(photoListObservableObject: observableObject)
        #if os(iOS)
            assertSnapshot(
                of: view,
                // as: .wait(for: 5, on: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light)))
                as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light))
            )
        #endif
    }

    func test_listWithMultipleElements() throws {
        // given
        let expectation = expectation(description: #function)
        let observableObject = PhotoListObservableObject(imagesService: imagesService)
        let fixture = try getFixture("curated_photos_multiple_photos_response.json", as: GetCuratedImagesResponse.self)
        // when
        httpClient.enqueueHandler = { _ in
            Just(fixture)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        observableObject.$photos
            .dropFirst()
            .sink(receiveValue: { _ in expectation.fulfill() })
            .store(in: &cancellables)

        observableObject.loadMorePhotos()
        wait(for: [expectation], timeout: 1)

        // then
        let view = PhotoListView(photoListObservableObject: observableObject)
        #if os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light))
            )
        #endif
    }

    // MARK: - Helpers

    override func setUp() {
        super.setUp()
        cancellables = []
        httpClient = HTTPClientMock()
        imagesService = ImagesService(httpClient: httpClient)
    }
}
