import Combine
import SwiftUI

@available(macOS 15.0, *)
public struct PhotoListView: View {
    @StateObject
    var observedObject: PhotoListObservableObject

    public init(photoListObservableObject: PhotoListObservableObject) {
        _observedObject = StateObject(wrappedValue: photoListObservableObject)
    }

    public var body: some View {
        List(observedObject.photos) { photo in
            PhotoRowView(photo: photo)
                .onAppear {
                    if photo.id == observedObject.photos.last?.id {
                        observedObject.loadMorePhotos()
                    }
                }
        }
        .onAppear {
            observedObject.loadMorePhotos()
        }
        .navigationTitle("Photos")
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

                // Average Color Square
                Color(hex: photo.avgColor)
                    .frame(width: 20, height: 20)
                    .cornerRadius(4)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }

    private var imageView: some View {
        AsyncImage(url: photo.src.tiny) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(5)
        } placeholder: {
            ProgressView()
                .frame(width: 50, height: 50)
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

extension Photo: Identifiable {}
