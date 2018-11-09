import Foundation

protocol ServiceProtocol {
    func performTask(with request: URLRequest,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func object(for key: String) -> AnyObject?
    func set(obj: Any, for key: String)
}

struct Service {
    private let session: SessionProtocol
    private let dispatcher: Dispatcher
    private let cache: Cacheable

    init(session: SessionProtocol = Session(),
         cache: Cacheable = DefaultCache(),
         dispatcher: Dispatcher = DefaultDispatcher()) {
        self.session = session
        self.cache = cache
        self.dispatcher = dispatcher
    }
}

extension Service: ServiceProtocol {
    func performTask(with request: URLRequest,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: request) { (responseData, urlResponse, responseError) in
            self.dispatcher.dispatch {
                completion(responseData, urlResponse, responseError)
            }
        }
    }
    
    func object(for key: String) -> AnyObject? {
        return cache.object(for: key)
    }
    
    func set(obj: Any, for key: String) {
        cache.set(obj: obj, for: key)
    }
    
    func dispatch(completion: @escaping () -> Void) {
        dispatcher.dispatch {
            completion()
        }
    }
}
