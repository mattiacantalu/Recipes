import XCTest
@testable import RecipesApp

class ServiceFacadeTests: XCTestCase {
    
    func testGetRecipesShouldSuccess() {
        guard let data = JSONUtil.loadData(fromResource: "Recipes") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession.simulate(success: data) { request in
            XCTAssertEqual(request.url?.absoluteString, "www.sample.com/sampleapifortest/recipes.json")
        }
        
        ServiceFacade(configuration: configurate(session: session))
            .getRecipes(completion: { result in
                switch result {
                case .success(let response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(response.count, 9)
                    XCTAssertEqual(response.first?.name, "Crock Pot Roast")
                case .failure(let error):
                    XCTFail("Should be success! Got: \(error)")
                }
            })
    }
    
    func testGetRecipesShouldFail() {
        let session = MockedSession.simulate(failure: MockedSessionError.invalidResponse) { request in
            XCTAssertEqual(request.url?.absoluteString, "www.sample.com/sampleapifortest/recipes.json")
        }
        
        ServiceFacade(configuration: configurate(session: session))
            .getRecipes(completion: { result in
                switch result {
                case .success(_):
                    XCTFail("Should be fail! Got success.")
                case .failure(let error):
                    guard case MockedSessionError.invalidResponse = error else {
                        XCTFail("Unexpected error!")
                        return
                    }
                }
            })
    }
    
    private func configurate(session: SessionProtocol) -> Configuration {
        let service = Service(session: session,
                              dispatcher: SyncDispatcher())
        return Configuration(baseUrl: "www.sample.com",
                             service: service)
    }
}
