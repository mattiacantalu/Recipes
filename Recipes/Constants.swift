import Foundation

struct Constants {
    struct URL {
        static let httpMethod = "GET"
        static let baseUrl = "https://mattiacantalu.altervista.org"
    }
    
    struct Error {
        static let responseError = "An error has occurred"
        static let noData = "No data fetched"
        static let wrongUrl = "Unexpected URL creation exception"
    }
    
    struct Time {
        static let low = "0-10min"
        static let medium = "10-20min"
        static let high = "20+min"
    }
    
    struct Difficulty {
        static let easy = "Easy"
        static let medium = "Medium"
        static let hard = "Hard"
    }
    
    struct Title {
        static let recipes = "Recipes"
        static let difficulty = "Select difficulty"
        static let range = "Select time range"
        static let reset = "Reset"
        static let ingredients = "ingredients"
        static let minutes = "minutes"
        static let step = "Step"
        static let instructions = "Instructions"
        static let time = "Time"
        static let cancel = "Cancel"
    }
    
    struct Storyboard {
        static let name = "Main"
    }
    
    struct Cache {
        static let standard = 3600
    }
    
    struct Cell {
        static let productListCell = "productListCell"
        static let productPageCell = "productPageCell"
    }
}
