import XCTest
@testable import RecipesApp

class CacheFacadeTests: XCTestCase {

    func testSetObjectForKeyTriggeringExpirationShoudlReturnNil() {
        let cache = CacheFacade(expiration: 0)
        let item = CacheableItem(value: Data())
        cache.set(obj: item, for: "key")
        XCTAssertNil(cache.object(for: "key"))
    }
    
    func testSetObjectForKeyNoTriggeringExpirationShoudlReturnValue() {
        let cache = CacheFacade(expiration: 10)
        let item = CacheableItem(value: Data())
        cache.set(obj: item, for: "key")
        XCTAssertNotNil(cache.object(for: "key"))
    }
    
    func testGetObjectForNotSetKeyShoudlReturnNil() {
        let cache = CacheFacade(expiration: 0)
        XCTAssertNil(cache.object(for: "key"))
    }
    
    func testValidDateShouldReturnTrue() {
        XCTAssertTrue(Date().isValid(TimeInterval(10)))
    }
    
    func testValidDateShouldReturnFalse() {
        XCTAssertFalse(Date().isValid(TimeInterval(0)))
    }
}
