import Combine
import Foundation
@testable import PexelsLib

@available(macOS 15.0, *)
class HTTPClientMock: HTTPClient {
    // MARK: - enqueue

    var enqueueCallCount = 0

    var enqueueHandler: ((HTTPRequest) -> Any)?
    func enqueue<Model: Codable>(_ request: HTTPRequest) -> AnyPublisher<Model, any Error> {
        enqueueCallCount += 1
        // if let handlerResult = enqueueHandler(request), let result = handlerResult as? AnyPublisher<Model, Error> {
        if let result = enqueueHandler?(request) as? AnyPublisher<Model, any Error> {
            return result
        }
        return Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}
