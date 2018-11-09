import XCTest
@testable import RecipesApp

class ProductListPresenterTests: XCTestCase {
    var fetchData: MockedFetchDataInteractor?
    var filterData: MockedFilterDataInteractor?

    var view: MockedProductListView?
    var sut: ProductListPresenter?
    
    var mockedRecipe: Recipe {
        let ingredient = Ingredient(quantity: "1 1/2 tbsp",
                                    name: "olive oil",
                                    type: "Condiments")
        return Recipe(name: "Roasted Asparagus",
                      ingredients: [ingredient],
                      steps: ["Preheat oven to 425°F."],
                      timers: [0, 10, 5, 15],
                      imageURL: "http://sampleImage.url",
                      originalURL: nil)
    }

    override func setUp() {
        sut = ProductListPresenter()
        view = MockedProductListView()
        fetchData = MockedFetchDataInteractor()
        filterData = MockedFilterDataInteractor()
        
        sut?.fetchData = fetchData
        sut?.filterData = filterData
        sut?.view = view
    }
    
    func testFetchRecipesShouldPerform() {
        sut?.fetchRecipes()
        XCTAssertEqual(fetchData?.counterPerform, 1)
    }
    
    func testFilterByTextShouldPerform() {
        sut?.filter(by: "")
        XCTAssertEqual(filterData?.counterPerform, 1)
    }
    
    func testFilterByRangeShouldPerform() {
        sut?.filter(by: (0, 0))
        XCTAssertEqual(filterData?.counterPerform, 1)
    }
    
    func testFilterByDifficultyShoudlPerform() {
        sut?.filter(by: (0,0), steps: (0,0), timer: (0,0))
        XCTAssertEqual(filterData?.counterPerform, 1)
    }

    func testResetShouldPerform() {
        sut?.reset()
        XCTAssertEqual(view?.counterShowRecipes, 1)
    }
    
    func testOnRecipesShouldShowRecipes() {
        sut?.on(recipes: [])
        XCTAssertEqual(view?.counterShowRecipes, 1)
    }
    
    func testOnFilteredShouldShowFiltered() {
        sut?.on(filtered: [])
        XCTAssertEqual(view?.counterShowFiltered, 1)
    }
    
    func testOnErrorShouldCallShowError() {
        sut?.on(error: MockedError.fake)
        XCTAssertEqual(view?.counterShowError, 1)
    }
    
    func testByTextIntoNameShouldSuccess() {
        let result = sut?.by(text: "roasted") ?? { _ in return false }
        XCTAssertTrue(result(mockedRecipe))
    }
    
    func testByTextIntoIngredientShouldSuccess() {
        let result = sut?.by(text: "oil") ?? { _ in return false }
        XCTAssertTrue(result(mockedRecipe))
    }
    
    func testByTextIntoStepsShouldSuccess() {
        let result = sut?.by(text: "425") ?? { _ in return false }
        XCTAssertTrue(result(mockedRecipe))
    }
    
    func testByTextShouldFail() {
        let result = sut?.by(text: "apple") ?? { _ in return false }
        XCTAssertFalse(result(mockedRecipe))
    }
    
    func testByRangeIntoTimerShouldSuccess() {
        let result = sut?.by(range: (10, 30)) ?? { _ in return false }
        XCTAssertTrue(result(mockedRecipe))
    }
    
    func testByRangeIntoTimerShouldFail() {
        let result = sut?.by(range: (5, 20)) ?? { _ in return false }
        XCTAssertFalse(result(mockedRecipe))
    }
    
    func testByDifficultyShouldSuccess() {
        let result = sut?.by(ingredients: (1, 5), steps: (1, 5), timer: (5, 40)) ?? { _ in return false }
        XCTAssertTrue(result(mockedRecipe))
    }
    
    func testByDifficultyShouldFail() {
        let result = sut?.by(ingredients: (1, 5), steps: (1, 5), timer: (5, 10)) ?? { _ in return false }
        XCTAssertFalse(result(mockedRecipe))
    }
}

private enum MockedError: Error {
    case fake
}
