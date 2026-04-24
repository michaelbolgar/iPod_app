import XCTest
@testable import Networking

final class SHA1Tests: XCTestCase {

    func testKnownHash() {
        // SHA1("abc") = a9993e364706816aba3e25717850c26c9cd0d89d — известное значение
        XCTAssertEqual(SHA1.hash("abc"), "a9993e364706816aba3e25717850c26c9cd0d89d")
    }

    func testDifferentInputsProduceDifferentHashes() {
        XCTAssertNotEqual(SHA1.hash("input1"), SHA1.hash("input2"))
    }
}
