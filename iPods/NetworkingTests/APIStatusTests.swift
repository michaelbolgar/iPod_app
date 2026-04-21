import XCTest
@testable import Networking

final class APIStatusTests: XCTestCase {

    private let decoder = JSONDecoder()

    func testDecodesBool_True() throws {
        let data = "true".data(using: .utf8)!
        let status = try decoder.decode(APIStatus.self, from: data)
        XCTAssertTrue(status.isOK)
    }

    func testDecodesBool_False() throws {
        let data = "false".data(using: .utf8)!
        let status = try decoder.decode(APIStatus.self, from: data)
        XCTAssertFalse(status.isOK)
    }

    func testDecodesString_True() throws {
        let data = "\"true\"".data(using: .utf8)!
        let status = try decoder.decode(APIStatus.self, from: data)
        XCTAssertTrue(status.isOK)
    }

    func testDecodesString_False() throws {
        let data = "\"false\"".data(using: .utf8)!
        let status = try decoder.decode(APIStatus.self, from: data)
        XCTAssertFalse(status.isOK)
    }

    func testDecodesString_TrueUppercase() throws {
        let data = "\"True\"".data(using: .utf8)!
        let status = try decoder.decode(APIStatus.self, from: data)
        XCTAssertTrue(status.isOK)
    }
}
