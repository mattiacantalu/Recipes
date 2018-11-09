import UIKit

class ProductListCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var ingredientsLabel: UILabel?
    @IBOutlet private weak var minutesLabel: UILabel?

    var imageService: ImageProtocol?

    var recipe: Recipe? {
        didSet {
         load(recipe)
        }
    }
    
    func load(_ rc: Recipe?) {
        imageService?.downloadImage(from: rc?.imageURL) { image in
            self.imageView?.image = image
        }
        titleLabel?.text = rc?.name
        ingredientsLabel?.text = "\(rc?.ingredients.count ?? 0) \(Constants.Title.ingredients)"
        minutesLabel?.text = "\(rc?.timers.reduce(0, +) ?? 0) \(Constants.Title.minutes)"
    }
}
