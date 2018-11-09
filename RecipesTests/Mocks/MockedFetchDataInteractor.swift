import Foundation
@testable import RecipesApp

class MockedFetchDataInteractor: FetchDataInteractorProtocol {
    var counterPerform: Int =  0
    
    var performHandler: (() -> Void)?

    func perform() {
        counterPerform += 1
        if let performHandler = performHandler {
            return performHandler()
        }
    }
}
