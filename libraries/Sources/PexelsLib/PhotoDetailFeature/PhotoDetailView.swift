import Combine
import SwiftUI

@available(macOS 15.0, *)
public struct PhotoDetailView: View {
    let photo: Photo

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            imageView

            Text(photo.photographer)
                .font(.title2)
                .fontWeight(.bold)

            Text(photo.alt)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)

            secondaryInfoView
            tertiaryInfoView
            Spacer()
        }
        .padding()
        .navigationTitle("Photo Details")
    }

    private var imageView: some View {
        AsyncImage(url: photo.src.large ?? photo.src.original) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
        } placeholder: {
            ProgressView()
        }
        .frame(height: 300)
    }

    private var secondaryInfoView: some View {
        HStack {
            Text("Photo URL:")
                .font(.caption)
                .fontWeight(.bold)
            Spacer()
            Text(photo.url.absoluteString)
                .font(.caption)
                .foregroundColor(.blue)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }

    private var tertiaryInfoView: some View {
        HStack {
            Text("Photographer URL:")
                .font(.caption)
                .fontWeight(.bold)
            Spacer()
            Text(photo.photographerUrl.absoluteString)
                .font(.caption)
                .foregroundColor(.blue)
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }
}
