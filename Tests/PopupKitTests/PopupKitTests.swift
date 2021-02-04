import XCTest
@testable import PopupKit

final class PopupKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PopupKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
