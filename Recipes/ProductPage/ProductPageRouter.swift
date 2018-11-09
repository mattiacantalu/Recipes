import Foundation
import UIKit

class ProductPageRouter {
    let view: ProductPageViewController?
    
    init(recipe: RecipeProtocol?) {
        view = UIStoryboard(name: Constants.Storyboard.name, bundle: nil)
            .instantiateViewController(withIdentifier: "productPageViewController") as? ProductPageViewController
        
        let imageService = ImageService(cache: CacheFacade())

        let presenter = ProductPagePresenter()
        view?.presenter = presenter
        view?.imageService = ImageFacade(configuration: imageService)
        presenter.view = view
        presenter.recipe = recipe
    }
}
