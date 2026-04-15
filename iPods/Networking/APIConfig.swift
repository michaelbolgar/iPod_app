import Foundation

/// Credentials and base configuration for talking to the PodcastIndex API.
public struct APIConfig: Sendable {
    public let apiKey: String
    public let apiSecret: String
    public let baseURL: URL
    public let userAgent: String

    /// Creates a configuration with explicit values.
    public init(apiKey: String, apiSecret: String, baseURL: URL, userAgent: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.baseURL = baseURL
        self.userAgent = userAgent
    }

    /// Default PodcastIndex base URL.
    public static let defaultBaseURL = URL(string: "https://api.podcastindex.org/api/1.0")!

    /// Builds a configuration by reading credentials from a bundle's `Info.plist`.
    /// - Parameters:
    ///   - bundle: Bundle to read keys from. Defaults to `.main`.
    ///   - userAgent: Override for the `User-Agent` header. If `nil`, derived from the bundle's
    ///                `CFBundleName` and `CFBundleShortVersionString`.
    /// - Throws: ``APIError/misconfigured`` if `PodcastAPIKey` or `PodcastAPISecret` are missing.
    public static func fromBundle(
        _ bundle: Bundle = .main,
        userAgent: String? = nil
    ) throws -> APIConfig {
        guard
            let key = bundle.object(forInfoDictionaryKey: "PodcastAPIKey") as? String,
            let secret = bundle.object(forInfoDictionaryKey: "PodcastAPISecret") as? String,
            !key.isEmpty, !secret.isEmpty
        else {
            throw APIError.misconfigured
        }
        return APIConfig(
            apiKey: key,
            apiSecret: secret,
            baseURL: defaultBaseURL,
            userAgent: userAgent ?? makeUserAgent(from: bundle)
        )
    }

    private static func makeUserAgent(from bundle: Bundle) -> String {
        let name = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "App"
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        return "\(name)/\(version)"
    }
}
