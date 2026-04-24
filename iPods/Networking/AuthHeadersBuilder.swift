import Foundation

struct AuthHeadersBuilder: Sendable {
    private let config: APIConfig

    init(config: APIConfig) {
        self.config = config
    }

    func headers(date: Date = Date()) -> [String: String] {
        let timestamp = String(Int(date.timeIntervalSince1970))
        let hash = SHA1.hash(config.apiKey + config.apiSecret + timestamp)
        return [
            "User-Agent": config.userAgent,
            "X-Auth-Key": config.apiKey,
            "X-Auth-Date": timestamp,
            "Authorization": hash
        ]
    }
}
