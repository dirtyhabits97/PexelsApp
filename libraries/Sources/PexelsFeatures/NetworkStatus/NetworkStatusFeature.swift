import SwiftUI

public typealias NetworkStatusFeatureDependencies = NetworkStatusObservableObject

@available(macOS 15.0, *)
public final class NetworkStatusFeature {
    private let dependencies: NetworkStatusFeatureDependencies

    public init(dependencies: NetworkStatusFeatureDependencies) {
        self.dependencies = dependencies
    }

    public func buildView() -> some View {
        NetworkStatusView(
            networkStatusObservableObject: dependencies
        )
    }
}
