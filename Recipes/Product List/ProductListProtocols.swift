import Foundation
import UIKit

protocol ProductListPresenterProtocol {
    func fetchRecipes()
    func select(recipe: Recipe?)
    func filter(by text: String)
    func filter(by time: (min: Int, max: Int))
    func filter(by ingredients: (Int, Int), steps: (Int, Int), timer: (Int, Int))
    func reset()
    
    func on(recipes: [Recipe])
    func on(filtered: [Recipe])
    func on(error: Error)

    func by(text: String) -> (Recipe) -> Bool
    func by(range: (Int, Int)) -> (Recipe) -> Bool
    func by(ingredients: (Int, Int), steps: (Int, Int), timer: (Int, Int)) -> (Recipe) -> Bool
}

protocol ProductListViewProtocol: class {
    func show(recipes: [Recipe])
    func show(filtered: [Recipe])
    func show(error: Error)
}

protocol FetchDataInteractorProtocol {
    func perform()
}

protocol FilterDataInteractorProtocol {
    func perform(filter: (Recipe) -> Bool, on recipes: [Recipe]?)
}
