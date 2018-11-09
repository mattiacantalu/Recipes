import XCTest
@testable import RecipesApp

class UtilsTests: XCTestCase {
    
    func testUrlStringShouldReturnValidUrl() {
        let urlString = "http://sample.com"
        guard let url = URL(string: urlString) else {
            XCTFail("Url error!")
            return
        }
        let validUrl = urlString.url
        XCTAssertNotNil(validUrl)
        XCTAssertEqual(validUrl, url)
    }
    
    func testEmptyUrlStringShouldReturnNil() {
        XCTAssertNil("".url)
    }

    func testNilUrlStringShouldReturnNil() {
        let urlString: String? = nil
        XCTAssertNil(urlString?.url)
    }
}
