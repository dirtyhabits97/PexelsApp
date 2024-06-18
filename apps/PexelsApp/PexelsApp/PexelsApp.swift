//
//  PexelsAppApp.swift
//  PexelsApp
//
//  Created by Gonzalo Reyes Huertas on 15/06/24.
//

import SwiftUI
import PexelsLib
import PexelsFeatures
import RealmSwift
import Kingfisher

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
            videoFeature: videoFeature
        )
        return PhotoListFeature(dependencies: dependencies)
    }()
    
    lazy var videoFeature: VideoFeature = {
        let ids = [
            1526909,
            5386411,
            6963395,
            7438482,
            1409899,
            3163534,
            2169880,
            857251,
            856973,
            1093662,
        ]
        let videoService = VideoService(httpClient: httpClient)
        let dependencies = VideoDetailObservableObject(videoService: videoService, videoIds: ids)
        return VideoFeature(dependencies: dependencies)
    }()
    
    init() {
        let cache = Kingfisher.ImageCache.default
        cache.diskStorage.config.sizeLimit = 50 * 1024 * 1024 // 50 MB
    }
}
