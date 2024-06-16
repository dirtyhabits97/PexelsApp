import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
public typealias VideoFeatureDependencies = VideoDetailObservableObject

@available(macOS 15.0, *)
public final class VideoFeature {
    private let dependencies: VideoFeatureDependencies

    public init(dependencies: VideoFeatureDependencies) {
        self.dependencies = dependencies
    }

    public func buildView() -> some View {
        VideoDetailView(
            videoDetailObservableObject: dependencies
        )
    }
}
