import Foundation

protocol NetworkClientProtocol: Sendable {
    func request<T: APIResponse>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkClient: NetworkClientProtocol, Sendable {
    private static let maxRetries = 2

    private let config: APIConfig
    private let session: URLSession
    private let decoder: JSONDecoder
    private let headersBuilder: AuthHeadersBuilder

    init(config: APIConfig, session: URLSession? = nil) {
        self.config = config
        self.session = session ?? Self.defaultSession()
        self.headersBuilder = AuthHeadersBuilder(config: config)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        self.decoder = decoder
    }

    func request<T: APIResponse>(_ endpoint: Endpoint) async throws -> T {
        try await request(endpoint, attempt: 0)
    }

    private func request<T: APIResponse>(_ endpoint: Endpoint, attempt: Int) async throws -> T {
        do {
            return try await performRequest(endpoint)
        } catch let error where shouldRetry(error, attempt: attempt) {
            try await Task.sleep(for: .milliseconds(300))
            return try await request(endpoint, attempt: attempt + 1)
        }
    }

    private func shouldRetry(_ error: Error, attempt: Int) -> Bool {
        guard attempt < Self.maxRetries else { return false }
        switch error {
        case APIError.transport:
            return true
        case APIError.http(let code) where (500..<600).contains(code):
            return true
        default:
            return false
        }
    }

    private func performRequest<T: APIResponse>(_ endpoint: Endpoint) async throws -> T {
        let url = try buildURL(for: endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (field, value) in headersBuilder.headers() {
            request.setValue(value, forHTTPHeaderField: field)
        }

        #if DEBUG
        print("→ \(url)")
        #endif

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch is CancellationError {
            throw CancellationError()
        } catch let urlError as URLError where urlError.code == .cancelled {
            throw CancellationError()
        } catch {
            #if DEBUG
            print("✗ transport: \(error.localizedDescription)")
            #endif
            throw APIError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.apiFailure("Unexpected response type")
        }

        #if DEBUG
        print("← \(http.statusCode) \(url.lastPathComponent)")
        #endif

        guard (200..<300).contains(http.statusCode) else {
            throw APIError.http(statusCode: http.statusCode)
        }

        let decoded: T
        do {
            decoded = try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }

        guard decoded.isSuccess else {
            throw APIError.apiFailure(decoded.failureMessage)
        }
        return decoded
    }

    private func buildURL(for endpoint: Endpoint) throws -> URL {
        guard var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        components.path = (components.path as NSString).appendingPathComponent(endpoint.path)
        components.queryItems = endpoint.queryItems
        guard let url = components.url else { throw APIError.invalidURL }
        return url
    }

    private static func defaultSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: configuration)
    }
}
