import Combine
import Foundation
@testable import PexelsLib

@available(macOS 15.0, *)
class HTTPClientMock: HTTPClient {
    // MARK: - enqueue

    var enqueueCallCount = 0

    func enqueue<Model: Codable>(_: HTTPRequest) -> AnyPublisher<Model, Error> {
        enqueueCallCount += 1
        return Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}
