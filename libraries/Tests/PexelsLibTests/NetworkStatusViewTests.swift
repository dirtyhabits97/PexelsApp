import Combine
@testable import PexelsFeatures
@testable import PexelsLib
import SnapshotTesting
import XCTest

@available(macOS 15.0, *)
final class NetworkStatusViewTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var networkStatusStream = NetworkStatusStreamMock()

    func test_viewWithOfflineStatus() {
        // given
        let observableObject = NetworkStatusObservableObject(networkStatusStream: networkStatusStream)
        // then
        let view = NetworkStatusView(networkStatusObservableObject: observableObject)
        assertCompactSnapshots(of: view)
    }

    func test_viewWithWiFiStatus() {
        // given
        let expectation = expectation(description: #function)
        let observableObject = NetworkStatusObservableObject(networkStatusStream: networkStatusStream)
        // when
        observableObject.$networkStatus
            .dropFirst(2)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)

        networkStatusStream.update(status: .wifi)
        wait(for: [expectation], timeout: 1)
        // then
        let view = NetworkStatusView(networkStatusObservableObject: observableObject)
        assertCompactSnapshots(of: view)
    }

    func test_viewWithCellularStatus() {
        // given
        let expectation = expectation(description: #function)
        let observableObject = NetworkStatusObservableObject(networkStatusStream: networkStatusStream)
        // when
        observableObject.$networkStatus
            .dropFirst(2)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)

        networkStatusStream.update(status: .cellular)
        wait(for: [expectation], timeout: 1)
        // then
        let view = NetworkStatusView(networkStatusObservableObject: observableObject)
        assertCompactSnapshots(of: view)
    }

    override func setUp() {
        super.setUp()
        cancellables = []
        networkStatusStream = NetworkStatusStreamMock()
    }
}
