import Foundation

// Conform to observable object so SwiftUI can see changes
class Favourites: ObservableObject {
    @Published private(set) var attractionIDs: Set<String>
    private let key = "Favorites"

    init() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            attractionIDs = Set(saved)
        } else {
            attractionIDs = []
        }
    }

    func contains(_ attraction: Attraction) -> Bool {
        attractionIDs.contains(attraction.id)
    }

    func add(_ attraction: Attraction) {
        attractionIDs.insert(attraction.id)
        save()
    }

    func remove(_ attraction: Attraction) {
        attractionIDs.remove(attraction.id)
        save()
    }

    private func save() {
        UserDefaults.standard.set(Array(attractionIDs), forKey: key)
    }
}
