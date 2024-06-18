import Foundation
import RealmSwift

// TODO: There's a problem with the API
// where the same photo is returned in a different page.
// what we can do is
// A) Create a wrapper
// B) Create a local Id that is a combination of the page and the id hashed together.
public struct Photo: Codable, Identifiable, LocalStorageObject {
    public let id: Int
    public let url: URL?
    public let photographer: String
    public let photographerUrl: URL?
    public let photographerId: Int
    public let avgColor: String
    public let src: PhotoSource
    public let alt: String

    public func asRealmModel() -> PhotoModel {
        let model = PhotoModel()
        model.id = id
        model.url = url?.absoluteString
        model.photographer = photographer
        model.photographerUrl = photographerUrl?.absoluteString
        model.photographerId = photographerId
        model.avgColor = avgColor
        
        model.src = PhotoSourceModel()
        model.src?.originalUrl = src.original?.absoluteString
        model.src?.largeUrl = src.large?.absoluteString
        model.src?.tinyUrl = src.tiny?.absoluteString
        
        model.alt = alt
        return model
    }

    public static func build(using model: PhotoModel) -> Photo {
        let source = PhotoSource(
            original: URL(string: model.src?.originalUrl),
            large: URL(string: model.src?.largeUrl),
            tiny: URL(string: model.src?.tinyUrl
            )
        )
        return Photo(
            id: model.id,
            url: URL(string: model.url),
            photographer: model.photographer,
            photographerUrl: URL(string: model.photographerUrl),
            photographerId: model.photographerId,
            avgColor: model.avgColor,
            src: source,
            alt: model.alt
        )
    }
}

public struct PhotoSource: Codable {
    public let original: URL?
    public let large: URL?
    public let tiny: URL?
}

// 'RLMException', reason: 'Object property 'src' must be marked as optional.'
// According to the docs, one-to-one relationships must be optional
// https://stackoverflow.com/a/50874423
public final class PhotoModel: Object {
    @Persisted(primaryKey: true) var primaryKey = UUID()
    @Persisted var id: Int
    @Persisted var url: String?
    @Persisted var photographer: String
    @Persisted var photographerUrl: String?
    @Persisted var photographerId: Int
    @Persisted var avgColor: String
    @Persisted var src: PhotoSourceModel?
    @Persisted var alt: String
}

final class PhotoSourceModel: Object {
    @Persisted var originalUrl: String?
    @Persisted var largeUrl: String?
    @Persisted var tinyUrl: String?
}
