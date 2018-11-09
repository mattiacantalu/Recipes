import Foundation

class FilterDataInteractor {
    private let presenter: ProductListPresenterProtocol
    
    init(presenter: ProductListPresenterProtocol) {
        self.presenter = presenter
    }
}

extension FilterDataInteractor: FilterDataInteractorProtocol {
    func perform(filter: (Recipe) -> Bool,
                 on recipes: [Recipe]?) {
        let filtered = recipes?.filter({ filter($0) }) ?? []
        presenter.on(filtered: filtered)
    }
}
