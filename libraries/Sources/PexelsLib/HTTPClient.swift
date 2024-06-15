import Combine
import Foundation

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
