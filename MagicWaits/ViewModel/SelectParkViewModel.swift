import Foundation
import Combine

class SelectParkViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    
    private var cancellable: AnyCancellable?
    private var parksDataService: ParksDataService
    
    // initialise parks data service
    init(parksDataService: ParksDataService = ParksDataService()) {
        self.parksDataService = parksDataService
    }
    
    func getParkList() async throws {
        Task {
            do {
                let data = try await parksDataService.getParksData()
                DispatchQueue.main.async {
                    self.destinations = data
                }
            } catch {
                print("Failed to fetch parks list:", error)
            }
        }
    }
}
