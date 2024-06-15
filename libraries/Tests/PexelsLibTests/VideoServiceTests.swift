import Combine
@testable import PexelsLib
import XCTest

@available(macOS 15.0, *)
final class VideoServiceTests: XCTestCase {
    func test_httpClientIsCalled() {
        // given
        let httpClient = HTTPClientMock()
        let videoService = VideoService(httpClient: httpClient)
        var subscriptions = Set<AnyCancellable>()
        XCTAssertEqual(httpClient.enqueueCallCount, 0)
        // when
        videoService
            .getVideoMetadata(GetVideoMetadataRequest(id: 0))
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscriptions)
        // then
        XCTAssertEqual(httpClient.enqueueCallCount, 1)
    }
}
