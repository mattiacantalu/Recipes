import Foundation

protocol SessionProtocol {
    func dataTask(with request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

struct Session: SessionProtocol {
    private let session: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.session = urlSession
    }
    
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        let task = session.dataTask(with: request) { (responseData, urlResponse, responseError) in
            completion(responseData, urlResponse, responseError)
        }

        task.resume()
    }
}
