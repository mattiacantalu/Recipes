import Foundation
import UIKit

protocol ImageProtocol {
    func downloadImage(from link: String?,
                       completion: @escaping (_ image: UIImage?) -> Void)
}

struct ImageService {
    let session: URLSession
    let cache: Cacheable
    let dispatcher: Dispatcher
    
    init(urlSession: URLSession = URLSession.shared,
         cache: Cacheable = DefaultCache(),
         dispatcher: Dispatcher = DefaultDispatcher()) {
        self.session = urlSession
        self.cache = cache
        self.dispatcher = dispatcher
    }
}

struct ImageFacade {
    private let configuration: ImageService
    
    init(configuration: ImageService) {
        self.configuration = configuration
    }
    
    func performTask(with url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        
        if let cachedImage = configuration.cache.object(for: url.absoluteString) as? UIImage {
            self.dispatch {
                completion(cachedImage)
            }
            return
        }
        
        configuration.session.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    self.dispatch {
                        completion(nil)
                    }
                    return
            }
            
            self.dispatch {
                self.configuration.cache.set(obj: image, for: url.absoluteString)
                completion(image)
            }
            
            }.resume()
    }
}

extension ImageFacade {
    func dispatch(completion: @escaping () -> Void) {
        configuration.dispatcher.dispatch {
            completion()
        }
    }
}
