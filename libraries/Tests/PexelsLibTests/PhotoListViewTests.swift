import Combine
@testable import PexelsLib
import SnapshotTesting
import XCTest

@available(macOS 15.0, *)
final class PhotoListViewTests: XCTestCase {
    private var httpClient = HTTPClientMock()

    func test_viewWithOneElement() throws {
        // given
        let imageService = ImagesService(httpClient: httpClient)
        let observedObject = PhotoListObservableObject(imagesService: imageService)
        // when
        httpClient.enqueueHandler = { _ in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let fixtureURL = try getFixtureURL("curated_photos_single_photo_response.json")
                let response = try decoder.decode(GetCuratedImagesResponse.self, from: Data(contentsOf: fixtureURL))
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail<GetCuratedImagesResponse, Error>(error: error)
                    .eraseToAnyPublisher()
            }
        }
        // then
        // TODO: enable this test at some point
        // let view = PhotoListView(photoListObservableObject: observedObject)
        // #if os(iOS)
        //     assertSnapshot(
        //         of: view,
        //         as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light))
        //     )
        // #endif
    }

    override func setUp() {
        super.setUp()
        httpClient = HTTPClientMock()
    }
}

// #endif

func getFixtureURL(_ filename: String) throws -> URL {
    if let url = Bundle.module.url(forResource: filename, withExtension: nil) {
        return url
    }
    throw "Couldn't find \(filename) in the fixture folder."
}

extension String: Error {}
