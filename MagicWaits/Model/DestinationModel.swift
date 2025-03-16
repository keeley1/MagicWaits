import Foundation

struct Destination: Decodable {
    let id: String
    let name: String
    let parks: [Park]
}

struct Park: Decodable {
    let id: String
    let name: String
}
