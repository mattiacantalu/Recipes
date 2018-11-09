import Foundation

class ProductPagePresenter {
    weak var view: ProductPageViewProtocol?
    var recipe: RecipeProtocol?
}

extension ProductPagePresenter: ProductPagePresenterProtocol {
   func performFetch() {
        view?.loadCallbacks()
        view?.load(recipe: recipe?.fetch())
    }
}
