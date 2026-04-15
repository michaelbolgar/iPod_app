import Foundation

/// A single episode of a podcast.
public struct Episode: Decodable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let description: String?
    public let guid: String?
    public let datePublished: Date?
    public let enclosureType: String?
    public let enclosureLength: Int?
    public let duration: Int?
    public let feedId: Int
    public let feedTitle: String?

    private let enclosureUrl: String?
    private let image: String?
    private let feedImage: String?

    public var audioURL: URL? {
        guard let enclosureUrl else { return nil }
        return URL(string: enclosureUrl)
    }

    public var imageURL: URL? {
        if let i = image, !i.isEmpty { return URL(string: i) }
        if let f = feedImage, !f.isEmpty { return URL(string: f) }
        return nil
    }

    public static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
