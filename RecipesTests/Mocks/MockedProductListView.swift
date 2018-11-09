import Foundation
@testable import RecipesApp

class MockedProductListView: ProductListViewProtocol {
    var counterShowRecipes: Int =  0
    var counterShowFiltered: Int =  0
    var counterShowError: Int =  0
    var counterPush: Int =  0

    var showRecipesHandler: (([Recipe]) -> Void)?
    var showFilteredHandler: (([Recipe]) -> Void)?
    var showErrorHandler: ((Error) -> Void)?
    var pushHandler: ((RecipeProtocol) -> Void)?

    
    func show(recipes: [Recipe]) {
        counterShowRecipes += 1
        if let showRecipesHandler = showRecipesHandler {
            return showRecipesHandler(recipes)
        }
    }
    
    func show(filtered recipes: [Recipe]) {
        counterShowFiltered += 1
        if let showFilteredHandler = showFilteredHandler {
            return showFilteredHandler(recipes)
        }
    }
    
    func show(error: Error) {
        counterShowError += 1
        if let showErrorHandler = showErrorHandler {
            return showErrorHandler(error)
        }
    }
    
    func push(with delegate: RecipeProtocol) {
        counterPush += 1
        if let pushHandler = pushHandler {
            return pushHandler(delegate)
        }
    }
}
