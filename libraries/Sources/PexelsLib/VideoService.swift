import Combine
import Foundation

struct GetVideoMetadataRequest {
    let id: Int
}

struct GetVideoMetadataResponse: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: URL
    let image: URL
    let duration: Int
}

@available(macOS 15.0, *)
final class VideoService {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
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
