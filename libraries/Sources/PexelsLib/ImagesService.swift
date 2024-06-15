import Combine
import Foundation

public struct ImagesServiceConfig {
    let imagesPerPage = 15
    
    public init() { }
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

// TODO: There's a problem with the API
// where the same photo is returned in a different page.
// what we can do is
// A) Create a wrapper
// B) Create a local Id that is a combination of the page and the id hashed together.
public struct Photo: Codable {
    public let id: Int
    let width: Int
    let height: Int
    let url: URL
    let photographer: String
    let photographerUrl: URL
    let photographerId: Int
    let avgColor: String
    let src: PhotoSource
    let alt: String
}

struct PhotoSource: Codable {
    let tiny: URL
}

@available(macOS 15.0, *)
public final class ImagesService {
    private let config: ImagesServiceConfig
    private let httpClient: HTTPClient

    public init(config: ImagesServiceConfig = ImagesServiceConfig(), httpClient: HTTPClient) {
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
