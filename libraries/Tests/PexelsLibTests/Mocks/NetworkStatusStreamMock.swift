import Combine
@testable import PexelsLib

final class NetworkStatusStreamMock: MutableNetworkStatusStreaming {
    private let statusSubject = CurrentValueSubject<NetworkStatus, Never>(.offline)

    var status: AnyPublisher<NetworkStatus, Never> {
        statusSubject.eraseToAnyPublisher()
    }

    func update(status: NetworkStatus) {
        statusSubject.send(status)
    }
}
