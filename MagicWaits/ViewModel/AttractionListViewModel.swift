import Foundation
import Combine

class AttractionListViewModel: ObservableObject {
    @Published var attractions: [Attraction] = []
    
    private let parksDataService: ParksDataService
    private var cancellable: AnyCancellable?
    
    // initialise parks data service
    init(parksDataService: ParksDataService = ParksDataService()) {
        self.parksDataService = parksDataService
    }
    
    func fetchAttractionListData(parkId: String) {
        Task {
            do {
                let data = try await parksDataService.getAttractionData(parkId: parkId)
                DispatchQueue.main.async {
                    self.attractions = data
                }
            } catch {
                print("Failed to fetch data:", error)
            }
        }
    }
    
    func filterAttractionByStatus(attractions: [Attraction], status: LiveStatus) -> [Attraction] {
        return attractions.filter { $0.status == status }
    }
}
