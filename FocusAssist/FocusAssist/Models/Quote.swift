import Foundation

struct Quote: Codable, Identifiable {
    let q: String   // quote text
    let a: String   // author
    var id: String { q }
    var text: String { q }
    var author: String { a }
}
