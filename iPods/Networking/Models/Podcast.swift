import Foundation

/// A podcast feed (one show) returned by the PodcastIndex API.
public struct Podcast: Decodable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let link: String?
    public let description: String?
    public let author: String?
    public let ownerName: String?
    public let lastUpdateTime: Date?
    public let categories: [String: String]?
    public let language: String?
    public let episodeCount: Int?

    private let url: String?
    private let image: String?
    private let artwork: String?

    public var feedURL: URL? {
        guard let url else { return nil }
        return URL(string: url)
    }

    public var imageURL: URL? {
        if let a = artwork, !a.isEmpty { return URL(string: a) }
        if let i = image, !i.isEmpty { return URL(string: i) }
        return nil
    }

    public static func == (lhs: Podcast, rhs: Podcast) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
