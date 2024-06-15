import Combine
import Foundation

struct ImagesServiceConfig {
    let imagesPerPage = 15
}

struct GetCuratedImagesRequest {
    let page: Int

    init(page: Int = 1) {
        self.page = page
    }
}

struct GetCuratedImagesResponse: Codable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
    let nextPage: URL?
}

struct Photo: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: URL
    let photographer: String
    let photographerURL: URL
    let photographerId: Int
    let avgColor: String
    let alt: String
}

@available(macOS 15.0, *)
final class ImagesService {
    private let config: ImagesServiceConfig
    private let httpClient: HTTPClient

    init(config: ImagesServiceConfig = ImagesServiceConfig(), httpClient: HTTPClient) {
        self.config = config
        self.httpClient = httpClient
    }

    func getCuratedImages(_ request: GetCuratedImagesRequest) -> AnyPublisher<GetCuratedImagesResponse, Error> {
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
