import Foundation
import Combine

/*
 review how attractions are being retrieved
 */

class AttractionListViewModel: ObservableObject {
    @Published var attractions: [Attraction] = []
    private var initialAttractionList: [Attraction] = []
    
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
                    self.initialAttractionList = data
                    self.attractions = data
                }
            } catch {
                print("Failed to fetch data:", error)
            }
        }
    }
    
    // eventually update search to include land?? 
    func searchAttractions(searchTerm: String) {
        if searchTerm.isEmpty {
            attractions = initialAttractionList
        } else {
            attractions = attractions.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        }
    }
    
    func filterAttractionByStatus(status: LiveStatus) {
        attractions = attractions.filter { $0.status == status }
    }
    
    func filterAttractionsByType(type: EntityType) {
        attractions = attractions.filter { $0.entityType == type }
    }
    
    func returnAllAttractions() {
        attractions = initialAttractionList
    }
}
