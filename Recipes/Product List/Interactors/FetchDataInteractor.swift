import Foundation

class FetchDataInteractor {
    private let service: FacadeProtocol
    private let presenter: ProductListPresenterProtocol
    
    init(service: FacadeProtocol,
         presenter: ProductListPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

extension FetchDataInteractor: FetchDataInteractorProtocol {
    func perform() {
        service.getRecipes(completion: { result in
            switch result {
            case .success(let response):
                self.presenter.on(recipes: response)
            case .failure(let error):
                self.presenter.on(error: error)
            }
        })
    }
}
