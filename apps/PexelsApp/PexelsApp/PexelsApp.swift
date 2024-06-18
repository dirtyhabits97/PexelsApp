//
//  PexelsApp.swift
//  PexelsApp
//
//  Created by Gonzalo Reyes Huertas on 15/06/24.
//

import Kingfisher
import PexelsFeatures
import PexelsLib
import RealmSwift
import SwiftUI

@main
struct PexelsApp: SwiftUI.App {
    @StateObject var dependencyContainer = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                dependencyContainer.photoListFeature.buildView()
            }
        }
    }
}

final class DependencyContainer: ObservableObject {
    lazy var httpClient: HTTPClient = HTTPClientImpl(apiKey: ProcessInfo.processInfo.environment["PEXELS_API_KEY"] ?? "")
    lazy var localStorage: LocalStorage? = {
        do {
            let realm = try Realm()
            print("com.DependencyContainer: Realm path = \"\(realm.configuration.fileURL?.absoluteString)\"")
            return RealmStorage(realm: realm)
        } catch {
            print("com.DependencyContainer: Failed to start Realm \(error)")
            return nil
        }
    }()

    // MARK: - Features

    lazy var photoListFeature: PhotoListFeature = {
        let imageService = ImagesService(config: ImagesServiceConfig(), httpClient: httpClient)
        let photoListObservableObject = PhotoListObservableObject(
            imagesService: imageService,
            localStorage: localStorage
        )
        let dependencies: PhotoListFeatureDependencies = (
            photoListObservableObject: photoListObservableObject,
            videoFeature: videoFeature,
            networkStatusFeature: networkStatusFeature
        )
        return PhotoListFeature(dependencies: dependencies)
    }()

    lazy var videoFeature: VideoFeature = {
        let ids = [
            1_526_909,
            5_386_411,
            6_963_395,
            7_438_482,
            1_409_899,
            3_163_534,
            2_169_880,
            857_251,
            856_973,
            1_093_662,
        ]
        let videoService = VideoService(httpClient: httpClient)
        let dependencies = VideoDetailObservableObject(videoService: videoService, videoIds: ids)
        return VideoFeature(dependencies: dependencies)
    }()

    lazy var networkStatusFeature: NetworkStatusFeature = {
        let stream = NetworkStatusStream()
        let dependencies = NetworkStatusObservableObject(networkStatusStream: stream)
        return NetworkStatusFeature(dependencies: dependencies)
    }()

    init() {
        let cache = Kingfisher.ImageCache.default
        cache.diskStorage.config.sizeLimit = 50 * 1024 * 1024 // 50 MB
    }
}
