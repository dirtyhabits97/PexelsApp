import Combine
import Foundation

struct ImagesServiceConfig {
    let imagesPerPage = 15
}

struct GetCuratedImagesRequest {
    let page: Int = 15
}

struct GetCuratedImagesResponse: Codable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
    let nextPage: URL
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

// TODO: Move these abstractions to their own file
@available(macOS 15.0, *)
protocol HTTPClient {
    func enqueue<Model: Codable>(_: HTTPRequest) -> AnyPublisher<Model, Error>
}

@available(macOS 15.0, *)
final class HTTPClientImpl: HTTPClient {
    private let baseURL = URL(string: "https://api.pexels.com")!
    private let urlSession: URLSession

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Authorization": "TODO: Set this token",
        ]
        urlSession = URLSession(configuration: config)
    }

    // MARK: - HTTPClient

    func enqueue<Model: Codable>(_ request: HTTPRequest) -> AnyPublisher<Model, Error> {
        do {
            let urlRequest = try buildURLRequest(from: request)
            return urlSession
                .dataTaskPublisher(for: urlRequest)
                .map(\.data)
                .decode(type: Model.self, decoder: jsonDecoder)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }

    private func buildURLRequest(from httpRequest: HTTPRequest) throws -> URLRequest {
        let fullURL = baseURL.appendingPathComponent(httpRequest.endpoint)

        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: true) else {
            throw URLError(.badURL)
        }

        if let queryParams = httpRequest.queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpRequest.method.rawValue

        return request
    }
}

struct HTTPRequest {
    let endpoint: String
    let queryParams: [String: String]?
    let method: HTTPMethod
}

enum HTTPMethod: String {
    case get = "GET"
}
