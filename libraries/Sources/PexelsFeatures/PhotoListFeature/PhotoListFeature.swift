import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
public typealias PhotoListFeatureDependencies = (
    photoListObservableObject: PhotoListObservableObject,
    videoFeature: VideoFeature?
)

@available(macOS 15.0, *)
public final class PhotoListFeature {
    private let dependencies: PhotoListFeatureDependencies

    public init(dependencies: PhotoListFeatureDependencies) {
        self.dependencies = dependencies
    }

    public func buildView() -> some View {
        PhotoListView(
            photoListObservableObject: dependencies.photoListObservableObject,
            videoFeature: dependencies.videoFeature
        )
    }
}
