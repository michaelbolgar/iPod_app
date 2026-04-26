import Foundation
@testable import Networking

final class MockNetworkClient: NetworkClientProtocol, @unchecked Sendable {
    var result: (any APIResponse)?
    var errorToThrow: Error?

    func request<T: APIResponse>(_ endpoint: Endpoint) async throws -> T {
        if let error = errorToThrow {
            throw error
        }
        guard let result = result as? T else {
            throw APIError.decoding(NSError(domain: "Mock", code: 0))
        }
        return result
    }
}
