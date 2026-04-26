import Foundation

/// Service protocol for podcasts and episodes.
public protocol PodcastServiceProtocol: Sendable {
    func getTrending(max: Int) async throws -> [Podcast]
    func doSearch(query: String) async throws -> [Podcast]
    func getPodcastByID(_ id: Int) async throws -> Podcast
    func getEpisodes(feedID: Int, max: Int) async throws -> [Episode]
}

public extension PodcastServiceProtocol {
    /// Returns the most popular podcasts using the default page size.
    func getTrending() async throws -> [Podcast] {
        try await getTrending(max: 20)
    }

    /// Returns episodes of a podcast using the default page size.
    func getEpisodes(feedID: Int) async throws -> [Episode] {
        try await getEpisodes(feedID: feedID, max: 50)
    }
}

/// Public entry point for fetching podcasts and episodes from the PodcastIndex API.
public final class PodcastService: PodcastServiceProtocol, Sendable {
    private let client: NetworkClientProtocol

    /// Creates a service with an explicit configuration.
    public init(config: APIConfig, session: URLSession? = nil) {
        self.client = NetworkClient(config: config, session: session)
    }

    /// Reads API keys from Info.plist (`PodcastAPIKey`, `PodcastAPISecret`).
    /// - Throws: `APIError.misconfigured` if keys are missing.
    public convenience init(session: URLSession? = nil) throws {
        try self.init(config: .fromBundle(), session: session)
    }

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    /// Returns the most popular podcasts.
    /// - Parameter max: Maximum number of podcasts to return.
    public func getTrending(max: Int = 20) async throws -> [Podcast] {
        let response: FeedsResponse = try await client.request(.trending(max: max))
        return response.feeds
    }

    /// Searches podcasts by a free-text query.
    public func doSearch(query: String) async throws -> [Podcast] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        let response: FeedsResponse = try await client.request(.search(query: trimmed))
        return response.feeds
    }

    /// Fetches a single podcast by its PodcastIndex feed ID.
    public func getPodcastByID(_ id: Int) async throws -> Podcast {
        let response: PodcastByIDResponse = try await client.request(.podcastByID(id))
        guard let feed = response.feed else {
            throw APIError.apiFailure(response.failureMessage)
        }
        return feed
    }

    /// Returns episodes of a podcast, ordered as provided by the API.
    /// - Parameters:
    ///   - feedID: PodcastIndex feed ID of the podcast.
    ///   - max: Maximum number of episodes to return.
    public func getEpisodes(feedID: Int, max: Int = 50) async throws -> [Episode] {
        let response: EpisodesResponse = try await client.request(.episodesByFeedID(id: feedID, max: max))
        return response.items
    }
}
