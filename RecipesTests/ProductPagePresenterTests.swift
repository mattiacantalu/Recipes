import XCTest
@testable import RecipesApp

class ProductPagePresenterTests: XCTestCase {
    var view: MockedProductPageView?
    var sut: ProductPagePresenter?
    
    override func setUp() {
        sut = ProductPagePresenter()
        view = MockedProductPageView()
        
        sut?.view = view
    }
    
    func testFetchRecipeShouldSuccess() {
        sut?.performFetch()
        XCTAssertEqual(view?.counterLoadCallbacks, 1)
        XCTAssertEqual(view?.counterRecipe, 1)
    }
}
