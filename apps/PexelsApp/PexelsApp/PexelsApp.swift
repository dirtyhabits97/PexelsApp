//
//  PexelsAppApp.swift
//  PexelsApp
//
//  Created by Gonzalo Reyes Huertas on 15/06/24.
//

import SwiftUI
import PexelsLib

@main
struct PexelsApp: App {
    
    @StateObject var dependencyContainer = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PhotoListView(
                    photoListObservableObject: dependencyContainer.photoListObservableObject
                )
            }
        }
    }
}

final class DependencyContainer: ObservableObject {
    lazy var httpClient = HTTPClientImpl(apiKey: ProcessInfo.processInfo.environment["API_KEY"] ?? "")
    lazy var imageService = ImagesService(
        config: ImagesServiceConfig(),
        httpClient: httpClient
    )
    lazy var photoListObservableObject = PhotoListObservableObject(imagesService: imageService)
}
