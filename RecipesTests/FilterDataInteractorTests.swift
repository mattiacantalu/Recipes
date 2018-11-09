import XCTest
@testable import RecipesApp

class FitlerDataInteractorTests: XCTestCase {
    var presenter: MockedProductListPresenter?
    var sut: FilterDataInteractor?
    
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
        presenter = MockedProductListPresenter()
        guard let presenter = presenter else {
            XCTFail("Mocks fail!")
            return
        }
        sut = FilterDataInteractor(presenter: presenter)
    }
    
    func testPerformShouldFilterWithResult() {
        let filter: (Recipe) -> Bool = { return
            $0.name.contains("Roasted") == true
        }
        presenter?.onRecipesHandler = { recipe in
            XCTAssertEqual(recipe.count, 1)
        }
        sut?.perform(filter: filter,
                     on: [mockedRecipe])
        XCTAssertEqual(presenter?.counterOnFiltered, 1)
    }
    
    func testPerformShouldFilterWithNoResult() {
        let filter: (Recipe) -> Bool = { return
            $0.name.contains("apple") == true
        }
        presenter?.onRecipesHandler = { recipe in
            XCTAssertEqual(recipe.count, 0)
        }
        sut?.perform(filter: filter,
                     on: [mockedRecipe])
        XCTAssertEqual(presenter?.counterOnFiltered, 1)
    }
    
    func testPerformNoRecipesShouldReturnNoResult() {
        let filter: (Recipe) -> Bool = { return
            $0.name.contains("Roasted") == true
        }
        presenter?.onRecipesHandler = { recipe in
            XCTAssertEqual(recipe.count, 0)
        }
        sut?.perform(filter: filter,
                     on: nil)
        XCTAssertEqual(presenter?.counterOnFiltered, 1)
    }
}
