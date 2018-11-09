import Foundation
import UIKit

class ProductListRouter {
    let view: ProductListViewController?
    
    init() {
       
        view = UIStoryboard(name: Constants.Storyboard.name, bundle: nil)
            .instantiateViewController(withIdentifier: "productListViewController") as? ProductListViewController
        
        let presenter = ProductListPresenter()
        view?.presenter = presenter
        view?.imageService = imageService()
        presenter.view = view
        
        let fetchData = FetchDataInteractor(service: serviceFacade(),
                                            presenter: presenter)
        presenter.fetchData = fetchData
        
        let filterData = FilterDataInteractor(presenter: presenter)
        presenter.filterData = filterData
    }
}

private func serviceFacade() -> FacadeProtocol {
    let service = Service(session: Session(),
                          cache: CacheFacade())
    let config = Configuration(baseUrl: Constants.URL.baseUrl,
                               service: service)
    return ServiceFacade(configuration: config)
}

private func imageService() -> ImageProtocol {
    let service = ImageService(cache: CacheFacade())
    return ImageFacade(configuration: service)
}
