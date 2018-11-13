import XCTest
@testable import RecipesApp

class FetchDataInteractorTests: XCTestCase {
    var presenter: MockedProductListPresenter?
    var view: MockedProductListView?
    var service: ServiceFacade?
    var sut: FetchDataInteractor?
    
    override func setUp() {
        presenter = MockedProductListPresenter()
        view = MockedProductListView()
    }
    
    func testPerformGetRecipesShouldSuccess() {
        guard let data = JSONUtil.loadData(fromResource: "Recipes") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession.simulate(success: data) { request in
            XCTAssertEqual(request.url?.absoluteString, "www.sample.com/sample/recipes.json")
        }
        
        create(session: session)
        
        sut?.perform()
        XCTAssertEqual(presenter?.counterOnRecipes, 1)
        XCTAssertEqual(presenter?.counterOnError, 0)
    }
    
    func testPerformGetRecipesShouldFail() {
        let session = MockedSession.simulate(failure: MockedSessionError.invalidResponse) { request in
            XCTAssertEqual(request.url?.absoluteString, "www.sample.com/sample/recipes.json")
        }
        
        create(session: session)
        
        sut?.perform()
        XCTAssertEqual(presenter?.counterOnRecipes, 0)
        XCTAssertEqual(presenter?.counterOnError, 1)
    }
    
    private func create(session: SessionProtocol) {
        let config = Configuration(baseUrl: "www.sample.com",
                                   service: Service(session: session,
                                                    dispatcher: SyncDispatcher()))
        service = ServiceFacade(configuration: config)
        
        guard let presenter = presenter,
            let service = service else {
                XCTFail("Mocks fail!")
                return
        }
        
        sut = FetchDataInteractor(service: service,
                                  presenter: presenter)
    }
}
