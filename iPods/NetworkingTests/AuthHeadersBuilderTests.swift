import XCTest
@testable import Networking

final class AuthHeadersBuilderTests: XCTestCase {

    private var builder: AuthHeadersBuilder!

    override func setUp() {
        super.setUp()
        let config = APIConfig(
            apiKey: "testKey",
            apiSecret: "testSecret",
            baseURL: APIConfig.defaultBaseURL,
            userAgent: "TestApp/1.0"
        )
        builder = AuthHeadersBuilder(config: config)
    }

    func testHeadersContainRequiredKeys() {
        let headers = builder.headers()
        XCTAssertNotNil(headers["X-Auth-Key"])
        XCTAssertNotNil(headers["X-Auth-Date"])
        XCTAssertNotNil(headers["Authorization"])
        XCTAssertNotNil(headers["User-Agent"])
    }

    func testAuthKeyMatchesConfig() {
        let headers = builder.headers()
        XCTAssertEqual(headers["X-Auth-Key"], "testKey")
    }

    func testUserAgentMatchesConfig() {
        let headers = builder.headers()
        XCTAssertEqual(headers["User-Agent"], "TestApp/1.0")
    }

    func testAuthorizationIsCorrectSHA1() {
        let fixedDate = Date(timeIntervalSince1970: 1000000)
        let headers = builder.headers(date: fixedDate)
        let timestamp = "1000000"
        let expected = SHA1.hash("testKey" + "testSecret" + timestamp)
        XCTAssertEqual(headers["Authorization"], expected)
    }
}
