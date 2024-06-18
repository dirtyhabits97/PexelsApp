import Combine
import Kingfisher
import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
struct PhotoListView: View {
    @StateObject
    private var observedObject: PhotoListObservableObject
    @State
    private var isVideoDetailPresented = false
    @State
    private var isFirstTimeAppearing = true

    private let videoFeature: VideoFeature?
    private let networkStatusFeature: NetworkStatusFeature?

    init(
        photoListObservableObject: PhotoListObservableObject,
        videoFeature: VideoFeature? = nil,
        networkStatusFeature: NetworkStatusFeature? = nil
    ) {
        _observedObject = StateObject(wrappedValue: photoListObservableObject)
        self.videoFeature = videoFeature
        self.networkStatusFeature = networkStatusFeature
    }

    var body: some View {
        List(observedObject.photos) { photo in
            NavigationLink(destination: PhotoDetailView(photo: photo, networkStatusFeature: networkStatusFeature)) {
                PhotoRowView(photo: photo)
            }
            .onAppear {
                if photo.id == observedObject.photos.last?.id {
                    observedObject.loadMorePhotos()
                }
            }
        }
        .onAppear {
            if isFirstTimeAppearing {
                observedObject.loadMorePhotos()
                isFirstTimeAppearing = false
            }
        }
        .navigationTitle("Photos")
        #if os(iOS)
            .navigationBarItems(
                leading: leadingNavigationView,
                trailing: trailingNavigationButton
            )
        #endif
    }

    @ViewBuilder
    private var trailingNavigationButton: some View {
        if videoFeature != nil {
            Button(action: {
                isVideoDetailPresented = true
            }, label: {
                Image(systemName: "play.circle.fill")
                    .imageScale(.large)
            })
            .sheet(isPresented: $isVideoDetailPresented, content: {
                if let videoDetailView = videoFeature?.buildView() {
                    videoDetailView
                }
            })
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private var leadingNavigationView: some View {
        if let networkStatusFeature {
            networkStatusFeature.buildView()
        } else {
            EmptyView()
        }
    }
}

@available(macOS 15.0, *)
struct PhotoRowView: View {
    let photo: Photo

    var body: some View {
        HStack(spacing: 10) {
            imageView

            VStack(alignment: .leading, spacing: 4) {
                Text(photo.photographer)
                    .font(.headline)
                averageColor
            }
        }
    }

    private var imageView: some View {
        KFImage(photo.src.tiny)
            .placeholder {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .cornerRadius(5)
    }

    private var averageColor: some View {
        HStack(spacing: 4) {
            Color(hex: photo.avgColor)
                .frame(width: 20, height: 20)
                .cornerRadius(4)
            Text(photo.alt)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

// Source: https://medium.com/@developer.sreejithnp/how-to-use-hex-code-directly-in-swiftui-using-extensions-374efc2c3c2a
@available(macOS 15.0, *)
extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0

        Scanner(string: cleanHexCode).scanHexInt64(&rgb)

        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
