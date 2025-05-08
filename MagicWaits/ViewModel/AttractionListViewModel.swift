import Foundation
import SwiftUICore
import Combine

/*
 review how attractions are being retrieved
 */

class AttractionListViewModel: ObservableObject {
    @Published var attractions: [Attraction] = []
    private var initialAttractionList: [Attraction] = []
    
    private let parksDataService: ParksDataService
    private var cancellables = Set<AnyCancellable>()
    private let timerPublisher = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    @EnvironmentObject private var appState: AppState
    
    // initialise parks data service
    init(parksDataService: ParksDataService = ParksDataService(),
         appState: AppState) {
        self.parksDataService = parksDataService
        setupTimer()
    }
    
    func fetchAttractionListData(parkId: String) {
        Task {
            do {
                let data = try await parksDataService.getAttractionData(parkId: parkId)
                DispatchQueue.main.async {
                    self.initialAttractionList = data
                    self.attractions = data
                    self.favouriteAttractions()
                }
            } catch {
                print("Failed to fetch data:", error)
            }
        }
    }
    
    private func setupTimer() {
        timerPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                let currentParkId = self.appState.currentParkId
                self.fetchAttractionListData(parkId: currentParkId)
            }
            .store(in: &cancellables)
    }
    
    // eventually update search to include land?? 
    func searchAttractions(searchTerm: String) {
        if searchTerm.isEmpty {
            attractions = initialAttractionList
        } else {
            attractions = attractions.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        }
    }
    
    func filterAttractions(byType type: EntityType?, andStatus status: LiveStatus?) {
        attractions = initialAttractionList.filter { attraction in
            let matchesType = type == nil || attraction.entityType == type
            let matchesStatus = status == nil || attraction.status == status
            return matchesType && matchesStatus
        }
    }
    
    // Review these two functions:
    func toggleFavourite(attraction: Attraction) {
        if let index = initialAttractionList.firstIndex(where: { $0.id == attraction.id }) {
            let attractionToUpdate = initialAttractionList[index]
            attractionToUpdate.isFavourited.toggle()
            print("Updated \(attractionToUpdate.name) isFavourited to \(attractionToUpdate.isFavourited)")
        }
    }
    
    func favouriteAttractions() {
        print("Initial attractions count: \(initialAttractionList.count)")
        for attraction in initialAttractionList {
            print("Attraction: \(attraction.name), isFavourited: \(attraction.isFavourited)")
        }
        
        let filteredAttractions = initialAttractionList.filter { $0.isFavourited }
        print("Filtered attractions count: \(filteredAttractions.count)")
        
        if filteredAttractions.isEmpty {
            print("No favorite attractions found. Defaulting to all attractions.")
            attractions = initialAttractionList
        } else {
            attractions = filteredAttractions
        }
    }
    
    func returnAllAttractions() {
        attractions = initialAttractionList
    }
}
