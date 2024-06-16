import Foundation

// TODO: There's a problem with the API
// where the same photo is returned in a different page.
// what we can do is
// A) Create a wrapper
// B) Create a local Id that is a combination of the page and the id hashed together.
public struct Photo: Codable, Identifiable {
    public let id: Int
    let width: Int
    let height: Int
    let url: URL
    let photographer: String
    let photographerUrl: URL
    let photographerId: Int
    let avgColor: String
    let src: PhotoSource
    let alt: String
}

struct PhotoSource: Codable {
    let original: URL
    let large2x: URL?
    let large: URL?
    let medium: URL?
    let small: URL?
    let portrait: URL?
    let landscape: URL?
    let tiny: URL
}
