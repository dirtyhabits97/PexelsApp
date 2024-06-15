import Combine
@testable import PexelsLib
import XCTest

@available(macOS 15.0, *)
final class ImagesServiceTests: XCTestCase {
    func test_httpClientIsCalled() {
        // given
        let httpClient = HTTPClientMock()
        let imagesService = ImagesService(httpClient: httpClient)
        var subscriptions = Set<AnyCancellable>()
        XCTAssertEqual(httpClient.enqueueCallCount, 0)
        // when
        imagesService
            .getCuratedImages(GetCuratedImagesRequest())
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscriptions)
        // then
        XCTAssertEqual(httpClient.enqueueCallCount, 1)
    }
}
