import Foundation

// TODO: There's a problem with the API
// where the same photo is returned in a different page.
// what we can do is
// A) Create a wrapper
// B) Create a local Id that is a combination of the page and the id hashed together.
public struct Photo: Codable, Identifiable {
    public let id: Int
    public let width: Int
    public let height: Int
    public let url: URL
    public let photographer: String
    public let photographerUrl: URL
    public let photographerId: Int
    public let avgColor: String
    public let src: PhotoSource
    public let alt: String
}

public struct PhotoSource: Codable {
    public let original: URL
    public let large2x: URL?
    public let large: URL?
    public let medium: URL?
    public let small: URL?
    public let portrait: URL?
    public let landscape: URL?
    public let tiny: URL
}
