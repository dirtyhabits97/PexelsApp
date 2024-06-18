import Combine
import Kingfisher
import PexelsLib
import SwiftUI

@available(macOS 15.0, *)
struct PhotoDetailView: View {
    private let photo: Photo
    private let networkStatusFeature: NetworkStatusFeature?

    init(
        photo: Photo,
        networkStatusFeature: NetworkStatusFeature? = nil
    ) {
        self.photo = photo
        self.networkStatusFeature = networkStatusFeature
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            imageView

            Text(photo.photographer)
                .font(.title2)
                .fontWeight(.bold)

            Text(photo.alt)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)

            colorInfoView
            secondaryInfoView
            tertiaryInfoView
            Spacer()
        }
        .padding()
        .navigationTitle("Photo")
        #if os(iOS)
            .navigationBarItems(
                trailing: trailingNavigationButton
            )
        #endif
    }

    private var imageView: some View {
        KFImage(photo.src.large ?? photo.src.original)
            .placeholder {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            .frame(height: 300)
    }

    private var colorInfoView: some View {
        HStack {
            Text("Average color:")
                .font(.caption)
                .fontWeight(.bold)
            Color(hex: photo.avgColor)
                .frame(width: 20, height: 20)
                .cornerRadius(4)
        }
    }

    private var secondaryInfoView: some View {
        HStack {
            Text("Photo URL:")
                .font(.caption)
                .fontWeight(.bold)
            Spacer()
            if let photoUrl = photo.url {
                Text(photoUrl.absoluteString)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
    }

    private var tertiaryInfoView: some View {
        HStack {
            Text("Photographer URL:")
                .font(.caption)
                .fontWeight(.bold)
            Spacer()
            if let photographerUrl = photo.photographerUrl {
                Text(photographerUrl.absoluteString)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
    }

    @ViewBuilder
    private var trailingNavigationButton: some View {
        if let networkStatusFeature {
            networkStatusFeature.buildView()
        } else {
            EmptyView()
        }
    }
}
