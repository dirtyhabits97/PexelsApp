import Combine
import Foundation

public struct ImagesServiceConfig {
    let imagesPerPage = 15

    public init() {}
}

package struct GetCuratedImagesRequest {
    package let page: Int

    package init(page: Int = 1) {
        self.page = page
    }
}

package struct GetCuratedImagesResponse: Codable {
    package let page: Int
    package let perPage: Int
    package let photos: [Photo]
    package let nextPage: URL?
}

@available(macOS 15.0, *)
public final class ImagesService {
    private let config: ImagesServiceConfig
    private let httpClient: HTTPClient

    public init(config: ImagesServiceConfig = ImagesServiceConfig(), httpClient: HTTPClient) {
        self.config = config
        self.httpClient = httpClient
    }

    package func getCuratedImages(
        _ request: GetCuratedImagesRequest
    ) -> AnyPublisher<GetCuratedImagesResponse, Error> {
        let request = HTTPRequest(
            endpoint: "/v1/curated",
            queryParams: [
                "page": String(request.page),
                "per_page": String(config.imagesPerPage),
            ],
            method: .get
        )
        return httpClient.enqueue(request)
    }
}
