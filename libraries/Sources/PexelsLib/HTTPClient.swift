import Combine
import Foundation

@available(macOS 15.0, *)
public protocol HTTPClient {
    func enqueue<Model: Codable>(_: HTTPRequest) -> AnyPublisher<Model, Error>
}

@available(macOS 15.0, *)
public final class HTTPClientImpl: HTTPClient {
    private let urlSession: URLSession
    
    let baseURL = URL(string: "https://api.pexels.com")!
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public init(apiKey: String) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Authorization": apiKey,
        ]
        urlSession = URLSession(configuration: config)
    }

    // MARK: - HTTPClient

    public func enqueue<Model: Codable>(_ request: HTTPRequest) -> AnyPublisher<Model, Error> {
        do {
            let urlRequest = try buildURLRequest(from: request)
            return urlSession
                .dataTaskPublisher(for: urlRequest)
                .map(\.data)
                .map { data in
                    print("com.HTTPClient: Data \(String(data: data, encoding: .utf8))")
                    return data
                }
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

public struct HTTPRequest {
    let endpoint: String
    let queryParams: [String: String]?
    let method: HTTPMethod

    init(endpoint: String, queryParams: [String: String]? = nil, method: HTTPMethod) {
        self.endpoint = endpoint
        self.queryParams = queryParams
        self.method = method
    }
}

public enum HTTPMethod: String {
    case get = "GET"
}
