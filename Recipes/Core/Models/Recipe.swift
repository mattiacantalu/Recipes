import Foundation

struct Recipe: Codable {
    let name: String
    let ingredients: [Ingredient]
    let steps: [String]
    let timers: [Int]
    let imageURL: String
    let originalURL: String?
}
