import Combine
import Foundation

package struct GetVideoMetadataRequest {
    package let id: Int

    package init(id: Int) {
        self.id = id
    }
}

package typealias GetVideoMetadataResponse = Video

@available(macOS 15.0, *)
public final class VideoService {
    private let httpClient: HTTPClient

    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    package func getVideoMetadata(
        _ request: GetVideoMetadataRequest
    ) -> AnyPublisher<GetVideoMetadataResponse, Error> {
        let request = HTTPRequest(
            endpoint: "/videos/videos/\(request.id)",
            method: .get
        )
        return httpClient.enqueue(request)
    }
}
