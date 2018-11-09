import Foundation
@testable import RecipesApp

class MockedFilterDataInteractor: FilterDataInteractorProtocol {
    var counterPerform: Int =  0
    
    var performHandler: (((Recipe) -> Bool, [Recipe]?) -> Void)?
    
    func perform(filter: (Recipe) -> Bool,
                 on recipes: [Recipe]?) {
        counterPerform += 1
        if let performHandler = performHandler {
            return performHandler(filter, recipes)
        }
    }
}
