import Foundation
@testable import RecipesApp

class MockedProductPageView: ProductPageViewProtocol {
    var counterRecipe: Int =  0
    var counterLoadCallbacks: Int =  0
    
    var loadRecipeHandler: ((Recipe?) -> Void)?
    var loadCallbacksHandler: (() -> Void)?
    

    func load(recipe: Recipe?) {
        counterRecipe += 1
        if let loadRecipeHandler = loadRecipeHandler {
            return loadRecipeHandler(recipe)
        }
    }
    
    func loadCallbacks() {
        counterLoadCallbacks += 1
        if let loadCallbacksHandler = loadCallbacksHandler {
            return loadCallbacksHandler()
        }
    }
}
