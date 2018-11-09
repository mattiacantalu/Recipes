import Foundation
import UIKit

private extension ProductListViewController {
    private typealias Times = [(
        title: String,
        range: (Int, Int))]
    private typealias Difficulty = [(
        title: String,
        ingredients: (Int, Int),
        steps: (Int, Int),
        timer: (Int, Int))]
    private static let timesFilter: Times = [(Constants.Time.low, (0, 10)),
                                             (Constants.Time.medium, (10, 20)),
                                             (Constants.Time.high, (20, 1000))]
    private static let difficultyFilter: Difficulty = [(Constants.Difficulty.easy, (0, 15), (0, 15), (0, 25)),
                                                     (Constants.Difficulty.medium, (0, 10), (5, 20), (20, 60)),
                                                     (Constants.Difficulty.hard, (0, 10), (5, 20), (60, 1000))]
}

final class ProductListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView?
    
    private var selected: Recipe?
    private var sectionCallbacks: [(() -> Bool, () -> Int)]?
    private var cellCallbacks: [(() -> Bool, (IndexPath) -> Recipe?)]?
    
    var presenter: ProductListPresenterProtocol?
    var imageService: ImageProtocol?
    
    private var recipes: [Recipe]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    private var filtered: [Recipe]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    private var isFilter = false
    private var isSearch: Bool {
        return (navigationItem.searchController?.searchBar.isFirstResponder ?? false) || isFilter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        callbacks()
        presenter?.fetchRecipes()
    }
    
    private func setup() {
        self.title = Constants.Title.recipes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.placeholder = "Search"
        definesPresentationContext = true
    }
    
    private func callbacks() {
        sectionCallbacks = [
            ({ return self.isSearch }, { return self.filtered?.count ?? 0 }),
            ({ return true }, { return self.recipes?.count ?? 0 })
        ]
        cellCallbacks = [
            ({ return self.isSearch }, { indexPath in return self.filtered?[indexPath.row] }),
            ({ return true }, { indexPath in return self.recipes?[indexPath.row] }),
        ]
    }
}

extension ProductListViewController: ProductListViewProtocol {
    func show(recipes: [Recipe]) {
        self.recipes = recipes
    }
    
    func show(filtered: [Recipe]) {
        self.filtered = filtered
    }
    
    func show(error: Error) {
        print(error)
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionCallbacks?.first(where: { $0.0() })?.1() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.productListCell, for: indexPath) as? ProductListCell

        cell?.imageService = imageService
        cell?.recipe = cellCallbacks?.first(where: { $0.0() })?.1(indexPath)
    
        return cell ?? ProductListCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter?.select(recipe: cellCallbacks?.first(where: { $0.0() })?.1(indexPath))
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.4, height: 190)
    }
}

extension ProductListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.filter(by: searchController.searchBar.text ?? "")
    }
}

extension ProductListViewController {
    @IBAction func onByDifficulty(_ sender : AnyObject){
        let times: (UIAlertController) -> Void = { alert in
            self.byDifficulty(alert: alert)
            
        }
        UIAlertController.show(message: Constants.Title.difficulty,
                               actions: times,
                               in: self)
    }
    
    @IBAction func onByTime(_ sender : AnyObject){
        let times: (UIAlertController) -> Void = { alert in
            self.byTime(alert: alert)
        }
        UIAlertController.show(message: Constants.Title.range,
                               actions: times,
                               in: self)
    }
}

private extension ProductListViewController {
    func byTime(alert: UIAlertController) {
        ProductListViewController.timesFilter.forEach({ time in
            let first = UIAlertAction(title: time.0, style: .default) { _ in
                self.isFilter = true
                self.presenter?.filter(by: time.1)
            }
            return alert.addAction(first)
        })
        let reset = UIAlertAction(title: "Reset",
                                  style: UIAlertAction.Style.destructive) { _ in
                                    self.isFilter = false
                                    self.presenter?.reset()
        }
        alert.addAction(reset)
    }
    
    func byDifficulty(alert: UIAlertController) {
        ProductListViewController.difficultyFilter.forEach({ difficulty in
            let first = UIAlertAction(title: difficulty.title, style: .default) { _ in
                self.isFilter = true
                self.presenter?.filter(by: difficulty.ingredients,
                                       steps: difficulty.steps,
                                       timer: difficulty.timer)
            }
            return alert.addAction(first)
        })
        let reset = UIAlertAction(title: Constants.Title.reset,
                                  style: UIAlertAction.Style.destructive) { _ in
                                    self.isFilter = false
                                    self.presenter?.reset()
        }
        alert.addAction(reset)
    }
}

