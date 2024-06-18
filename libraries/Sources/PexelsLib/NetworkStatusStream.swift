import Combine
import Network

public protocol NetworkStatusStreaming {
    var status: AnyPublisher<NetworkStatus, Never> { get }
}

public protocol MutableNetworkStatusStreaming: NetworkStatusStreaming {
    func update(status: NetworkStatus)
}

public enum NetworkStatus: String {
    case wifi = "WiFi"
    case cellular = "Cellular"
    case offline = "Offline"
}

public final class NetworkStatusStream: MutableNetworkStatusStreaming {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.NetworkStatusStream")
    private let statusSubject = CurrentValueSubject<NetworkStatus, Never>(.offline)

    public var status: AnyPublisher<NetworkStatus, Never> {
        statusSubject.eraseToAnyPublisher()
    }

    public init() {
        subscribeToChanges()
    }

    deinit {
        unsubscribeToChanges()
    }

    // MARK: - MutableNetworkStatusStreaming

    public func update(status: NetworkStatus) {
        statusSubject.send(status)
    }

    private func subscribeToChanges() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            guard path.status == .satisfied else {
                return self.update(status: .offline)
            }

            if path.usesInterfaceType(.wifi) {
                self.update(status: .wifi)
            } else if path.usesInterfaceType(.cellular) {
                self.update(status: .cellular)
            } else {
                self.update(status: .offline)
            }
        }
        monitor.start(queue: queue)
    }

    private func unsubscribeToChanges() {
        monitor.cancel()
    }
}
