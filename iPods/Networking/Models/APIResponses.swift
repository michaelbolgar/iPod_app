import Foundation

protocol APIResponse: Decodable {
    var status: APIStatus { get }
    var failureMessage: String? { get }
}

extension APIResponse {
    var isSuccess: Bool { status.isOK }
    var failureMessage: String? { nil }
}

struct FeedsResponse: APIResponse {
    let status: APIStatus
    let feeds: [Podcast]
    let count: Int?
    let failureMessage: String?

    enum CodingKeys: String, CodingKey {
        case status, feeds, count
        case failureMessage = "description"
    }
}

struct PodcastByIDResponse: APIResponse {
    let status: APIStatus
    let feed: Podcast?
    let failureMessage: String?

    enum CodingKeys: String, CodingKey {
        case status, feed
        case failureMessage = "description"
    }
}

struct EpisodesResponse: APIResponse {
    let status: APIStatus
    let items: [Episode]
    let count: Int?
    let failureMessage: String?

    enum CodingKeys: String, CodingKey {
        case status, items, count
        case failureMessage = "description"
    }
}

struct APIStatus: Decodable {
    let isOK: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let bool = try? container.decode(Bool.self) {
            isOK = bool
        } else {
            let string = try container.decode(String.self)
            isOK = string.lowercased() == "true"
        }
    }
}
