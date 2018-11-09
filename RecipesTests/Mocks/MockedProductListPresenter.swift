import Foundation
@testable import RecipesApp

class MockedProductListPresenter: ProductListPresenterProtocol {
    var counterFetchRecipes: Int =  0
    var counterFilterByText: Int =  0
    var counterFilterByTime: Int =  0
    var counterFilterByDifficulty: Int =  0
    var counterReset: Int =  0
    var counterSelectRecipe: Int =  0
    var counterOnRecipes: Int =  0
    var counterOnFiltered: Int =  0
    var counterOnError: Int =  0
    var counterByText: Int =  0
    var counterByRange: Int =  0
    var counterByDifficulty: Int =  0

    var fetchRecipesHandler: (() -> Void)?
    var filterByTextHandler: ((String) -> Void)?
    var filterByTimeHandler: (((Int, Int)) -> Void)?
    var filterByDifficultyHandler: (((Int, Int), (Int, Int), (Int, Int)) -> Void)?
    var resetHandler: (() -> Void)?
    var selectRecipeHandler: ((Recipe?) -> Void)?
    var onRecipesHandler: (([Recipe]) -> Void)?
    var onFilteredHandler: (([Recipe]) -> Void)?
    var onErrorHandler: ((Error) -> Void)?
    var byTextHandler: ((String) -> (Recipe) -> Bool)?
    var byRangeHandler: (((Int, Int)) -> (Recipe) -> Bool)?
    var byDifficultyHandler: (((Int, Int), (Int, Int), (Int, Int)) -> (Recipe) -> Bool)?

    func fetchRecipes() {
        counterFetchRecipes += 1
        if let fetchRecipesHandler = fetchRecipesHandler {
            return fetchRecipesHandler()
        }
    }
    
    func filter(by text: String) {
        counterFilterByText += 1
        if let filterByTextHandler = filterByTextHandler {
            return filterByTextHandler(text)
        }
    }
    
    func filter(by time: (min: Int, max: Int)) {
        counterFilterByTime += 1
        if let filterByTimeHandler = filterByTimeHandler {
            return filterByTimeHandler(time)
        }
    }

    func filter(by ingredients: (Int, Int), steps: (Int, Int), timer: (Int, Int)) {
        counterFilterByDifficulty += 1
        if let filterByDifficultyHandler = filterByDifficultyHandler {
            return filterByDifficultyHandler(ingredients, steps, timer)
        }
    }
    
    func reset() {
        counterReset += 1
        if let resetHandler = resetHandler {
            return resetHandler()
        }
    }

    func select(recipe: Recipe?) {
        counterSelectRecipe += 1
        if let selectRecipeHandler = selectRecipeHandler {
            return selectRecipeHandler(recipe)
        }
    }
    
    func on(recipes: [Recipe]) {
        counterOnRecipes += 1
        if let onRecipesHandler = onRecipesHandler {
            return onRecipesHandler(recipes)
        }
    }
    
    func on(filtered: [Recipe]) {
        counterOnFiltered += 1
        if let onFilteredHandler = onFilteredHandler {
            return onFilteredHandler(filtered)
        }
    }
    
    func on(error: Error) {
        counterOnError += 1
        if let onErrorHandler = onErrorHandler {
            return onErrorHandler(error)
        }
    }
    
    func by(text: String) -> (Recipe) -> Bool {
        counterByText += 1
        if let byTextHandler = byTextHandler {
            return byTextHandler(text)
        }
        return { _ in return false }
    }
    
    func by(range: (Int, Int)) -> (Recipe) -> Bool {
        counterByRange += 1
        if let byRangeHandler = byRangeHandler {
            return byRangeHandler(range)
        }
        return { _ in return false }
    }
    
    func by(ingredients: (Int, Int), steps: (Int, Int), timer: (Int, Int)) -> (Recipe) -> Bool {
        counterByDifficulty += 1
        if let byDifficultyHandler = byDifficultyHandler {
            return byDifficultyHandler(ingredients, steps, timer)
        }
        return { _ in return false }
    }
}
