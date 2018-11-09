# RECIPES

Recipes is an iOS application oriented toward the following patterns: 

✅ VIPER Architecture

✅ Protocol Oriented

✅ Functional Programming

✅ Clean Code

✅ Dependency Injection

✅ Unit Tests

It's based on a `GET` api and built over a `UICollectionView` and detailed `UITableView`.


## HOW IT WORKS

Each controller is built by 4 files
1. Router (routing layer)
2. Presenter (view logic)
3. Interactor (business logic for a use case)
4. View (display data)


### CONFIGURATION

The routing layer performs the injection:

🔸 Presenter

🔸 View

🔸 Interactor
```
view = UIStoryboard(name: Constants.Storyboard.name, bundle: nil)
        .instantiateViewController(withIdentifier: "productListViewController") as? ProductListViewController
        
let presenter = ProductListPresenter()
view?.presenter = presenter
view?.imageService = imageService()
presenter.view = view
   
let fetchData = FetchDataInteractor(service: serviceFacade(),
                                    presenter: presenter)
presenter.fetchData = fetchData
        
let filterData = FilterDataInteractor(presenter: presenter)
presenter.filterData = filterData
```

... building the main services of the application:

🔸 Cache facade
```
let cache = CacheFacade()
```

🔸 Service facade

```
private func serviceFacade() -> FacadeProtocol {
    let service = Service(session: Session(),
                          cache: CacheFacade())
    let config = Configuration(baseUrl: Constants.URL.baseUrl,
                               service: service)
    return ServiceFacade(configuration: config)
}
```
🔸 Image service
```
private func imageService() -> ImageProtocol {
    let service = ImageService(cache: CacheFacade())
    return ImageFacade(configuration: service)
}

```

### VIPER FLOW

1. View calls Presenter:

    ```
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchRecipes()
    }
    ```

2. Presenter performs Interactor call

    ```
    func fetchRecipes() {
        fetchData?.perform()
    }
    ```

3. Interactor executes "business logic" and notifies Presenter

    ```
    func perform() {
            // ...
            // bla bla bla
            // ...

            self.presenter.on(recipes: response)
    }
    ```

4. Presenter revices data from Interactor and notifies View

    ```
    func on(recipes: [Recipe]) {
        view?.show(recipes: recipes)
    }
    ```

5. View updates the UI
    ```
     func show(recipes: [Recipe]) {
         // bla bla bla
    }
    ```

### TESTS

Each module is unit tested (mocks oriented): decoding, mapping, services, presenter, interactor and view (and utilies for sure). 

1. Presenter sample test

```
    func testFetchRecipesShouldPerform() {
        sut?.fetchRecipes()
        XCTAssertEqual(fetchData?.counterPerform, 1)
    }
```

```
class MockedFilterDataInteractor: FilterDataInteractorProtocol {
    var counterPerform: Int =  0
    
    var performHandler: (((Recipe) -> Bool, [Recipe]?) -> Void)?
    
    func perform(filter: (Recipe) -> Bool,
                 on recipes: [Recipe]?) {
        counterPerform += 1
        if let performHandler = performHandler {
            return performHandler(filter, recipes)
        }
    }
}
```

2. Service sample test

```
func testGetRecipesShouldSuccess() {
        guard let data = JSONUtil.loadData(fromResource: "Recipes") else {
            XCTFail("JSON data error!")
            return
        }
        let session = MockedSession.simulate(success: data) { request in
            XCTAssertEqual(request.url?.absoluteString, "www.sample.com/sampleapifortest/recipes.json")
        }
        
        ServiceFacade(configuration: configurate(session: session))
            .getRecipes(completion: { result in
                switch result {
                case .success(let response):
                    XCTAssertNotNil(response)
                    XCTAssertEqual(response.count, 9)
                    XCTAssertEqual(response.first?.name, "Crock Pot Roast")
                case .failure(let error):
                    XCTFail("Should be success! Got: \(error)")
                }
            })
    }
```

3. Decoding/Mapping sample tests

```
    func testRecipeResponse() {
        do {
            let recipe = try JSONUtil.loadClass(fromResource: "Recipe", ofType: Recipe.self)
            XCTAssertEqual(recipe?.name, "Crock Pot Roast")
            XCTAssertEqual(recipe?.ingredients.count, 5)
            XCTAssertEqual(recipe?.ingredients.first?.quantity, "1")
            XCTAssertEqual(recipe?.ingredients.first?.name, " beef roast")
            XCTAssertEqual(recipe?.ingredients.first?.type, "Meat")
            XCTAssertEqual(recipe?.steps.count, 4)
            XCTAssertEqual(recipe?.steps.first, "Place beef roast in crock pot.")
            XCTAssertEqual(recipe?.timers.count, 4)
            XCTAssertEqual(recipe?.timers.last, 420)
            XCTAssertEqual(recipe?.imageURL, "http://img.sndimg.com/food/image/upload/w_266/v1/img/recipes/27/20/8/picVfzLZo.jpg")
            XCTAssertEqual(recipe?.originalURL, "http://www.food.com/recipe/to-die-for-crock-pot-roast-27208")
        } catch {
            XCTFail("Failed to decode: \(error)")
        }
    }
```

## CONTRIBUTORS
Any suggestions are welcome 👨🏻‍💻

## REQUIREMENTS
• Swift 4.2

• Xcode 10
