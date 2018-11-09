import UIKit

final class ProductPageViewController: UIViewController {
    var presenter: ProductPagePresenterProtocol?

    private var cellCallbacks: [((Int) -> Bool, (UITableView, IndexPath) -> UITableViewCell)]?
    private var rowsCallbacks: [((Int) -> Bool, () -> Int)]?
    private var titleCallbacks: [((Int) -> Bool, () -> String)]?

    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var imageView: UIImageView?
    
    var imageService: ImageProtocol?

    var recipe: Recipe? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.performFetch()
    }

    private func setup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func callbacks() {
        cellCallbacks = [({ section in return section == 0 }, ingredientCell),
                               ({ section in return section == 1 }, stepCell),
                               ({ section in return section == 2 }, timerCell)]
        rowsCallbacks = [({ section in return section == 0 }, numberOfIngredients),
                                 ({ section in return section == 1 }, numberOfSteps),
                                 ({ section in return section == 2 }, numberOfTimers)]
        titleCallbacks = [({ section in return section == 0 }, titleIngredients),
                          ({ section in return section == 1 }, titleSteps),
                          ({ section in return section == 2 }, titleTimers)]
    }
}

extension ProductPageViewController: ProductPageViewProtocol {
    func loadCallbacks() {
        callbacks()
    }

    func load(recipe: Recipe?) {
        self.recipe = recipe
        imageService?.downloadImage(from: recipe?.imageURL) { image in
            self.imageView?.image = image
        }
        self.title = recipe?.name
    }
}

extension ProductPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCallbacks?.first(where: { $0.0(section) })?.1() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellCallbacks?.first(where: { $0.0(indexPath.section) })?.1(tableView, indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleCallbacks?.first(where: { $0.0(section) })?.1() ?? ""
    }
}

private extension ProductPageViewController {
    func ingredientCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.productPageCell)
        let ingredient = recipe?.ingredients[indexPath.row]
        cell?.textLabel?.text = ingredient?.name
        cell?.detailTextLabel?.text = ingredient?.quantity
        return cell ?? UITableViewCell()
    }
    
    func stepCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.productPageCell)
        let step = recipe?.steps[indexPath.row]
        cell?.textLabel?.text = "\(Constants.Title.step) \(indexPath.row + 1): \(step ?? "")"
        cell?.detailTextLabel?.text = ""
        return cell ?? UITableViewCell()
    }
    
    func timerCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.productPageCell)
        let timer = recipe?.timers[indexPath.row]
        cell?.textLabel?.text = "\(Constants.Title.step) \(indexPath.row + 1): \(timer ?? 0)\(Constants.Title.minutes)"
        cell?.detailTextLabel?.text = ""
        return cell ?? UITableViewCell()
    }
}

private extension ProductPageViewController {
    func numberOfIngredients() -> Int {
        return recipe?.ingredients.count ?? 0
    }

    func numberOfSteps() -> Int {
        return recipe?.steps.count ?? 0
    }
    
    func numberOfTimers() -> Int {
        return recipe?.timers.count ?? 0
    }
}

private extension ProductPageViewController {
    func titleIngredients() -> String {
        return "\(Constants.Title.ingredients.uppercased()) \(recipe?.ingredients.count ?? 0)"
    }
    
    func titleSteps() -> String {
        return Constants.Title.instructions.uppercased()
    }
    
    func titleTimers() -> String {
        return Constants.Title.time.uppercased()
    }
}
