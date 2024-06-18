import Combine
@testable import PexelsLib
import RealmSwift
import XCTest

@available(macOS 15.0, *)
final class RealmStorageTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var realm: Realm?

    func test_saveAndLoad() throws {
        // given
        let expectation = expectation(description: #function)
        let fixture = try getFixture("curated_photos_multiple_photos_response.json",
                                     as: GetCuratedImagesResponse.self).photos
        let realm = try XCTUnwrap(realm)
        let storage = RealmStorage(realm: realm)
        // when
        try storage.saveToDisk(fixture)

        // then
        storage
            .loadFromDisk(Photo.self)
            .map { list in list.sorted(by: { $0.id < $1.id }) }
            .sink(receiveValue: { loadedItems in
                XCTAssertEqual(loadedItems.count, fixture.count)
                XCTAssertEqual(loadedItems.map(\.id), fixture.map(\.id))
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Wait for the load operation to complete
        wait(for: [expectation], timeout: 1)
    }

    func test_clearFromDisk() throws {
        // given
        let expectation = expectation(description: #function)
        let fixture = try getFixture("curated_photos_multiple_photos_response.json",
                                     as: GetCuratedImagesResponse.self).photos
        let realm = try XCTUnwrap(realm)
        let storage = RealmStorage(realm: realm)
        // when
        try storage.saveToDisk(fixture)
        try storage.clearFromDisk(Photo.self)

        // then
        storage
            .loadFromDisk(Photo.self)
            .sink(receiveValue: { loadedItems in
                XCTAssertEqual(loadedItems.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Wait for the load operation to complete
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - Helpers

    override func setUp() {
        super.setUp()
        cancellables = []
        realm = buildRealm()
    }

    private func buildRealm() -> Realm? {
        let config = Realm.Configuration(inMemoryIdentifier: "com.RealmStorageTests")
        return try? Realm(configuration: config)
    }
}
