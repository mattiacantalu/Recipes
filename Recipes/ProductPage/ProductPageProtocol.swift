import Foundation

protocol RecipeProtocol {
    func fetch() -> Recipe?
}

protocol ProductPagePresenterProtocol {
    func performFetch()
}

protocol ProductPageViewProtocol: class {
    func load(recipe: Recipe?)
    func loadCallbacks()
}
