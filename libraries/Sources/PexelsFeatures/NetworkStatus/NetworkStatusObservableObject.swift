import Combine
import Foundation
import PexelsLib

public final class NetworkStatusObservableObject: ObservableObject {
    @Published
    var networkStatus = NetworkStatus.offline

    private let networkStatusStream: NetworkStatusStreaming
    private var cancellables = Set<AnyCancellable>()

    public init(networkStatusStream: NetworkStatusStreaming) {
        self.networkStatusStream = networkStatusStream
        subscribe()
    }

    private func subscribe() {
        networkStatusStream
            .status
            .receive(on: DispatchQueue.main)
            .assign(to: \.networkStatus, on: self)
            .store(in: &cancellables)
    }
}
