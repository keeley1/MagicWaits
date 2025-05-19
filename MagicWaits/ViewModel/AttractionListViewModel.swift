import Foundation
import SwiftUICore
import Combine

/*
 review how attractions are being retrieved
 */

class AttractionListViewModel: ObservableObject {
    @Published var attractions: [Attraction] = []
    @Published var favAttractions: [Attraction] = []
    private var initialAttractionList: [Attraction] = []
    
    private let parksDataService: ParksDataService
    private var cancellables = Set<AnyCancellable>()
    private let timerPublisher = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    private let appState: AppState
    
    @Published var searchTerm: String = "" {
        didSet {
            searchAttractions(searchTerm: searchTerm)
        }
    }
    
    // initialise parks data service
    init(parksDataService: ParksDataService = ParksDataService(),
         appState: AppState) {
        self.parksDataService = parksDataService
        self.appState = appState
        setupTimer()
    }
    
    func fetchAttractionListData(parkId: String) {
        Task {
            do {
                let data = try await parksDataService.getAttractionData(parkId: parkId)
                DispatchQueue.main.async {
                    self.initialAttractionList = data
                    self.loadFavouriteState()
                    self.attractions = data
                    //self.favouriteAttractions()
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
            saveFavouriteState()
        }
    }
    
    // ATM favs are resetting when park is changed - need global fav list
    private func saveFavouriteState() {
        let favouriteIds = initialAttractionList.filter { $0.isFavourited }.map { $0.id }
        UserDefaults.standard.set(favouriteIds, forKey: "favouriteAttractions")
    }

    private func loadFavouriteState() {
        let favouriteIds = UserDefaults.standard.array(forKey: "favouriteAttractions") as? [String] ?? []
        for index in initialAttractionList.indices {
            initialAttractionList[index].isFavourited = favouriteIds.contains(initialAttractionList[index].id)
        }
        print("Loaded favourite state. Favourite IDs: \(favouriteIds)")
    }
    
    func favouriteAttractions() {
        self.loadFavouriteState()
        print("Initial attractions:", initialAttractionList)
        print("Attractions:", attractions)
        let filteredAttractions = initialAttractionList.filter { $0.isFavourited }
        print("Filtered attractions count: \(filteredAttractions.count)")
        self.favAttractions = filteredAttractions
    }
    
    func returnAllAttractions() {
        attractions = initialAttractionList
        print("Returning all attractions. Count: \(attractions.count)")
    }
}
