import Foundation

extension ServiceFacade: FacadeProtocol {
    func getRecipes(completion: @escaping ((Result<[Recipe]>) -> Void)) {
        let url = baseURL?
            .appendingPathComponent("sample")
            .appendingPathComponent("recipes.json")

        performTry({ try self.makeRequest(url,
                                          map: [Recipe].self,
                                          completion: completion) })
    }
}
