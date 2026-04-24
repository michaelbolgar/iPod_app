import XCTest
@testable import Networking

final class PodcastServiceTests: XCTestCase {

    var mock: MockNetworkClient!
    var service: PodcastService!

    override func setUp() {
        super.setUp()
        mock = MockNetworkClient()
        service = PodcastService(client: mock)
    }

    // MARK: - getTrending

    func testGetTrendingReturnsPodcasts() async throws {
        let podcast = try makePodcast(id: 1, title: "Swift Talk")
        mock.result = FeedsResponse(status: APIStatus(isOK: true), feeds: [podcast], count: 1, failureMessage: nil)

        let result = try await service.getTrending(max: 5)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].title, "Swift Talk")
    }

    // MARK: - doSearch

    func testDoSearchEmptyQueryReturnsEmpty() async throws {
        let result = try await service.doSearch(query: "")
        XCTAssertTrue(result.isEmpty)
    }

    func testDoSearchWhitespaceReturnsEmpty() async throws {
        let result = try await service.doSearch(query: "   ")
        XCTAssertTrue(result.isEmpty)
    }

    // MARK: - getPodcastByID

    func testGetPodcastByIDReturnsPodcast() async throws {
        let podcast = try makePodcast(id: 42, title: "The Daily")
        mock.result = PodcastByIDResponse(status: APIStatus(isOK: true), feed: podcast, failureMessage: nil)

        let result = try await service.getPodcastByID(42)

        XCTAssertEqual(result.id, 42)
        XCTAssertEqual(result.title, "The Daily")
    }

    func testGetPodcastByIDThrowsWhenFeedIsNil() async throws {
        mock.result = PodcastByIDResponse(status: APIStatus(isOK: true), feed: nil, failureMessage: "Not found")

        do {
            _ = try await service.getPodcastByID(42)
            XCTFail("Expected error")
        } catch APIError.apiFailure(let message) {
            XCTAssertEqual(message, "Not found")
        }
    }

    // MARK: - getEpisodes

    func testGetEpisodesReturnsItems() async throws {
        let episode = try makeEpisode(id: 10, title: "Episode 1")
        mock.result = EpisodesResponse(status: APIStatus(isOK: true), items: [episode], count: 1, failureMessage: nil)

        let result = try await service.getEpisodes(feedID: 1, max: 10)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].title, "Episode 1")
    }

    // MARK: - Error propagation

    func testCancelledTaskDoesNotRetry() async throws {
        mock.errorToThrow = CancellationError()

        do {
            _ = try await service.getTrending(max: 5)
            XCTFail("Expected CancellationError")
        } catch is CancellationError {
            // expected — cancellation propagates, not retried
        }
    }

    func testNetworkErrorPropagates() async throws {
        mock.errorToThrow = APIError.transport(URLError(.notConnectedToInternet))

        do {
            _ = try await service.getTrending(max: 5)
            XCTFail("Expected error")
        } catch APIError.transport {
            // expected
        }
    }

    // MARK: - Helpers

    private func makePodcast(id: Int, title: String) throws -> Podcast {
        let data = try JSONSerialization.data(withJSONObject: ["id": id, "title": title])
        return try JSONDecoder().decode(Podcast.self, from: data)
    }

    private func makeEpisode(id: Int, title: String) throws -> Episode {
        let data = try JSONSerialization.data(withJSONObject: ["id": id, "title": title, "feedId": 0])
        return try JSONDecoder().decode(Episode.self, from: data)
    }
}
