
@testable import PexelsLib
import XCTest

@available(macOS 15.0, *)
final class HTTPClientTests: XCTestCase {
    let client = HTTPClientImpl(apiKey: "")

    func test_baseUrlIsCorrect() {
        // given
        let baseURL = client.baseURL
        // then
        XCTAssertEqual(baseURL, URL(string: "https://api.pexels.com"))
    }

    func test_keyDecodingStrategyIsSnakeCase() {
        // given
        let decoder = client.jsonDecoder
        // then
        switch decoder.keyDecodingStrategy {
        case .convertFromSnakeCase:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected the decoding strategy to be `convertFromSnakeCase`")
        }
    }
}
