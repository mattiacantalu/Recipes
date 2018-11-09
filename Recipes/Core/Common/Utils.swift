import Foundation
import UIKit

func performTry(_ function: @escaping (() throws -> Void)) {
    do {
        return try function()
    } catch {
        print("❌ \(error) ❌")
    }
}

extension UIAlertController {
    static func show(message: String, actions: (UIAlertController) -> Void, in controller: UIViewController) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .actionSheet)
        actions(alert)
        defaults(alert)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    private static var defaults: (UIAlertController) -> Void {
        let defaultActions: (UIAlertController) -> Void = { alert in
            let cancel = UIAlertAction(title: Constants.Title.cancel,
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(cancel)
        }
        return defaultActions
    }
}
