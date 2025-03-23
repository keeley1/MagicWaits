import Foundation

// filtering logic here
import Foundation

class AttractionListViewModel: ObservableObject {
    func filterAttractionByStatus(attractions: [Attraction], status: LiveStatus) -> [Attraction] {
        return attractions.filter { $0.status == status }
    }
}
