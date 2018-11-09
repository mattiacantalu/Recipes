import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

protocol FacadeProtocol {
    func getRecipes(completion: @escaping ((Result<[Recipe]>) -> Void))
}

struct ServiceFacade {
    private let configuration: Configuration

    var baseURL: URL? {
        return URL(string: configuration.baseUrl)
    }

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    func makeRequest<T: Decodable>(_ url: URL?,
                                   map: T.Type,
                                   completion: @escaping ((Result<T>) -> Void)) throws {

        guard let url = url else {
            throw ServiceError.wrongUrl
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = Constants.URL.httpMethod

        if let data = configuration.service.object(for: url.absoluteString) as? T  {
            configuration.service.dispatch {
                completion(Result.success(data))
            }
            return
        }

        configuration
            .service
            .performTask(with: request) { (responseData, urlResponse, responseError) in
            completion(self.decode(response: responseData,
                                   map: map,
                                   error: responseError,
                                   url: url))
        }
    }
    
    private func decode<T: Decodable>(response: Data?,
                                      map: T.Type,
                                      error: Error?,
                                      url: URL) -> (Result<T>) {
        if let error = error {
            return (.failure(error))
        }

        guard let jsonData = response else {
            return (.failure(ServiceError.noData))
        }

        do {
            let decoded = try JSONDecoder().decode(map,
                                                   from: jsonData)
            configuration.service.set(obj: decoded, for: url.absoluteString)
            return (.success(decoded))
        } catch {
            return (.failure(error))
        }
    }
}
