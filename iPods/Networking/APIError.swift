import Foundation

/// Errors thrown by the Networking framework.
public enum APIError: LocalizedError {
    case invalidURL
    case transport(Error)
    case http(statusCode: Int)
    case decoding(Error)
    case apiFailure(String?)
    case misconfigured

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .transport(let error):
            return "Connection error: \(error.localizedDescription)"
        case .http(let code):
            return "Server error (\(code))"
        case .decoding(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .apiFailure(let message):
            return message.map { "API failure: \($0)" } ?? "API returned failure status"
        case .misconfigured:
            return "Missing API credentials. Check Secrets.xcconfig."
        }
    }
}
