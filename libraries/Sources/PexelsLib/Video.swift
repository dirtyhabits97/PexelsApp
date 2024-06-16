import Foundation

public struct Video: Codable, Identifiable {
    public let id: Int
    public let width: Int
    public let height: Int
    public let url: URL
    public let image: URL
    public let fullRes: URL?
    public let tags: [String]
    public let duration: Int
    public let user: VideoUser
    public let videoFiles: [VideoFile]
}

public struct VideoUser: Codable {
    public let id: Int
    public let name: String
    public let url: URL
}

public struct VideoFile: Codable {
    public let id: Int
    public let quality: String
    public let fileType: String
    public let width: Int
    public let height: Int
    public let fps: Float
    public let link: URL
}
