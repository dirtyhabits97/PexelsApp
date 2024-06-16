import Combine
import Foundation

struct GetVideoMetadataRequest {
    let id: Int
}

typealias GetVideoMetadataResponse = Video

@available(macOS 15.0, *)
public final class VideoService {
    private let httpClient: HTTPClient

    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func getVideoMetadata(_ request: GetVideoMetadataRequest) -> AnyPublisher<GetVideoMetadataResponse, Error> {
        let request = HTTPRequest(
            endpoint: "/videos",
            queryParams: [
                "id": String(request.id),
            ],
            method: .get
        )
        return httpClient.enqueue(request)
    }
}
