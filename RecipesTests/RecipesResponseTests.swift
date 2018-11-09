import XCTest
@testable import RecipesApp

class RecipesTests: XCTestCase {
    
    func testRecipeResponse() {
        do {
            let recipe = try JSONUtil.loadClass(fromResource: "Recipe", ofType: Recipe.self)
            XCTAssertEqual(recipe?.name, "Crock Pot Roast")
            XCTAssertEqual(recipe?.ingredients.count, 5)
            XCTAssertEqual(recipe?.ingredients.first?.quantity, "1")
            XCTAssertEqual(recipe?.ingredients.first?.name, " beef roast")
            XCTAssertEqual(recipe?.ingredients.first?.type, "Meat")
            XCTAssertEqual(recipe?.steps.count, 4)
            XCTAssertEqual(recipe?.steps.first, "Place beef roast in crock pot.")
            XCTAssertEqual(recipe?.timers.count, 4)
            XCTAssertEqual(recipe?.timers.last, 420)
            XCTAssertEqual(recipe?.imageURL, "http://img.sndimg.com/food/image/upload/w_266/v1/img/recipes/27/20/8/picVfzLZo.jpg")
            XCTAssertEqual(recipe?.originalURL, "http://www.food.com/recipe/to-die-for-crock-pot-roast-27208")
        } catch {
            XCTFail("Failed to decode: \(error)")
        }
    }
    
    func testRecipesResponse() {
        do {
            let recipes = try JSONUtil.loadClass(fromResource: "Recipes", ofType: [Recipe].self)
            XCTAssertEqual(recipes?.count, 9)
            let recipe = recipes?.first
            XCTAssertEqual(recipe?.name, "Crock Pot Roast")
            XCTAssertEqual(recipe?.ingredients.count, 5)
            XCTAssertEqual(recipe?.ingredients.first?.quantity, "1")
            XCTAssertEqual(recipe?.ingredients.first?.name, " beef roast")
            XCTAssertEqual(recipe?.ingredients.first?.type, "Meat")
            XCTAssertEqual(recipe?.steps.count, 4)
            XCTAssertEqual(recipe?.steps.first, "Place beef roast in crock pot.")
            XCTAssertEqual(recipe?.timers.count, 4)
            XCTAssertEqual(recipe?.timers.last, 420)
            XCTAssertEqual(recipe?.imageURL, "http://img.sndimg.com/food/image/upload/w_266/v1/img/recipes/27/20/8/picVfzLZo.jpg")
            XCTAssertEqual(recipe?.originalURL, "http://www.food.com/recipe/to-die-for-crock-pot-roast-27208")
            
            XCTAssertNil(recipes?.dropFirst().dropFirst().first?.originalURL)
        } catch {
            XCTFail("Failed to decode: \(error)")
        }
    }
}

