import Foundation
import UIKit

extension ImageFacade: ImageProtocol {
    func downloadImage(from link: String?,
                   completion: @escaping (_ image: UIImage?) -> Void) {
        
        guard let imageUrl = link?.url else {
            self.dispatch {
                completion(nil)
            }
            return
        }
        
        performTask(with: imageUrl,
                    completion: completion)
    }
}

extension String {
    var url: URL? {
        return [self].compactMap({ URL(string: $0) }).first ?? nil
    }
}
