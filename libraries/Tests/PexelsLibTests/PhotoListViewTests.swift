import Combine
@testable import PexelsLib
import SnapshotTesting
import XCTest

@available(macOS 15.0, *)
final class PhotoListViewTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    private var httpClient = HTTPClientMock()

    func test_viewWithOneElement() throws {
        // given
        let expectation = expectation(description: #function)
        let imageService = ImagesService(httpClient: httpClient)
        let observableObject = PhotoListObservableObject(imagesService: imageService)
        // when
        httpClient.enqueueHandler = { _ in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let fixtureURL = try getFixtureURL("curated_photos_single_photo_response.json")
                let data = try Data(contentsOf: fixtureURL)
                let response = try decoder.decode(GetCuratedImagesResponse.self, from: data)
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail<GetCuratedImagesResponse, Error>(error: error)
                    .eraseToAnyPublisher()
            }
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
        let view = PhotoListView(photoListObservableObject: observableObject)
        #if os(iOS)
            assertSnapshot(
                of: view,
                // as: .wait(for: 5, on: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light)))
                as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light))
            )
        #endif
    }

    override func setUp() {
        super.setUp()
        httpClient = HTTPClientMock()
        cancellables = []
    }
}
