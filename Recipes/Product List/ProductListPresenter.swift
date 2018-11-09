import Foundation
import UIKit

class ProductListPresenter {
    weak var view: ProductListViewProtocol?
    var fetchData: FetchDataInteractorProtocol?
    var filterData: FilterDataInteractorProtocol?

    private var recipe: Recipe?
    private var recipes: [Recipe]?
}

extension ProductListPresenter: ProductListPresenterProtocol {
    func fetchRecipes() {
        fetchData?.perform()
    }

    func filter(by text: String) {
        filterData?.perform(filter: by(text: text),
                            on: recipes)
    }
    
    func filter(by time: (min: Int, max: Int)) {
        filterData?.perform(filter: by(range: time),
                            on: recipes)
    }
    
    func filter(by ingredients: (Int, Int), steps: (Int, Int), timer: (Int, Int)) {
        filterData?.perform(filter: by(ingredients: ingredients,
                                       steps: steps,
                                       timer: timer),
                            on: recipes)
    }
    
    func select(recipe: Recipe?) {
        self.recipe = recipe
        push()
    }

    func reset() {
        view?.show(recipes: recipes ?? [])
    }

    func on(recipes: [Recipe]) {
        self.recipes = recipes
        view?.show(recipes: recipes)
    }
    
    func on(filtered: [Recipe]) {
        view?.show(filtered: filtered)
    }

    func on(error: Error) {
        view?.show(error: error)
    }
    
    func by(text: String) -> (Recipe) -> Bool {
        let filter: (Recipe) -> Bool = { return
            $0.name.lowercased().contains(text.lowercased()) == true ||
                $0.ingredients.filter({ (ingredient: Ingredient) in
                    return ingredient.name.lowercased().contains(text.lowercased())
                }).count > 0 ||
                $0.steps.filter({ (step: String) in
                    return step.lowercased().contains(text.lowercased())
                }).count > 0
        }
        return filter
    }
    
    func by(range: ((Int, Int))) -> (Recipe) -> Bool {
        let filter: (Recipe) -> Bool = { recipe in
            let sum = recipe.timers.reduce(0, +)
            return (sum >= range.0 && sum <= range.1)
        }
        return filter
    }
    
    func by(ingredients: (Int, Int), steps: (Int, Int), timer: (Int, Int)) -> (Recipe) -> Bool {
        let filter: (Recipe) -> Bool = { recipe in
            let ig = (recipe.ingredients.count >= ingredients.0 && recipe.ingredients.count <= ingredients.1)
            let sp = (recipe.steps.count >= steps.0 && recipe.steps.count <= steps.1)
            let tm = self.by(range: timer)(recipe)
            return ig && sp && tm
        }
        return filter
    }
}

private extension ProductListPresenter {
    func push() {
        ProductPageRouter(recipe: self).view
            .flatMap({ view.flatMap({ controller in return controller as? UIViewController })?
            .navigationController?.pushViewController($0, animated: true)  })
    }
}

extension ProductListPresenter: RecipeProtocol {
    func fetch() -> Recipe? {
        return recipe
    }
}
