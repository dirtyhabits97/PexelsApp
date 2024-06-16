import Foundation

struct Video: Codable, Identifiable {
    let id: Int
    let width: Int
    let height: Int
    let url: URL
    let image: URL
    let fullRes: URL?
    let tags: [String]
    let duration: Int
    let user: VideoUser
    let videoFiles: [VideoFile]
}

struct VideoUser: Codable {
    let id: Int
    let name: String
    let url: URL
}

struct VideoFile: Codable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int
    let height: Int
    let fps: Float
    let link: URL
}
