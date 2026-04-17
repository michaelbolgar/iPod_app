import Foundation

enum Endpoint {
    case trending(max: Int)
    case search(query: String)
    case podcastByID(Int)
    case episodesByFeedID(id: Int, max: Int)

    var path: String {
        switch self {
        case .trending:         return "/podcasts/trending"
        case .search:           return "/search/byterm"
        case .podcastByID:      return "/podcasts/byfeedid"
        case .episodesByFeedID: return "/episodes/byfeedid"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .trending(let max):
            return [URLQueryItem(name: "max", value: String(max))]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        case .podcastByID(let id):
            return [URLQueryItem(name: "id", value: String(id))]
        case .episodesByFeedID(let id, let max):
            return [
                URLQueryItem(name: "id", value: String(id)),
                URLQueryItem(name: "max", value: String(max))
            ]
        }
    }
}
