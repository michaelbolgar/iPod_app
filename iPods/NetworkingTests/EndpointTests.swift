import XCTest
@testable import Networking

final class EndpointTests: XCTestCase {

    func testTrendingPath() {
        XCTAssertEqual(Endpoint.trending(max: 20).path, "/podcasts/trending")
    }

    func testTrendingQueryItems() {
        let items = Endpoint.trending(max: 10).queryItems
        XCTAssertEqual(items.first?.name, "max")
        XCTAssertEqual(items.first?.value, "10")
    }

    func testSearchPath() {
        XCTAssertEqual(Endpoint.search(query: "swift").path, "/search/byterm")
    }

    func testSearchQueryItems() {
        let items = Endpoint.search(query: "swift").queryItems
        XCTAssertEqual(items.first?.name, "q")
        XCTAssertEqual(items.first?.value, "swift")
    }

    func testPodcastByIDPath() {
        XCTAssertEqual(Endpoint.podcastByID(42).path, "/podcasts/byfeedid")
    }

    func testEpisodesByFeedIDPath() {
        XCTAssertEqual(Endpoint.episodesByFeedID(id: 1, max: 50).path, "/episodes/byfeedid")
    }

    func testEpisodesByFeedIDQueryItems() {
        let items = Endpoint.episodesByFeedID(id: 1, max: 50).queryItems
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].name, "id")
        XCTAssertEqual(items[1].name, "max")
        XCTAssertEqual(items[1].value, "50")
    }
}
