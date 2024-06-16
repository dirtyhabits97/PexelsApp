import Combine
@testable import PexelsFeatures
@testable import PexelsLib
import SnapshotTesting
import XCTest

@available(macOS 15.0, *)
final class PhotoDetailViewTests: XCTestCase {
    func test_viewContents() throws {
        // given
        let fixture = try getFixture(
            "curated_photos_page_1.json",
            as: GetCuratedImagesResponse.self
        ).photos[0]
        // then
        let view = PhotoDetailView(photo: fixture)
        #if os(iOS)
            assertSnapshot(
                of: view,
                as: .image(layout: .device(config: .iPhoneSe), traits: .init(userInterfaceStyle: .light))
            )
        #endif
    }
}