import Foundation
import SwiftUICore
import Combine

/*
 review how attractions are being retrieved
 */

class AttractionListViewModel: ObservableObject {
    @Published var attractions: [Attraction] = []
    // @Published var favAttractions: [Attraction] = []
    @Published var currentType: EntityType? = nil
    @Published var currentStatus: LiveStatus? = nil
    private var initialAttractionList: [Attraction] = []
    
    private let parksDataService: ParksDataService
    private var cancellables = Set<AnyCancellable>()
    private let timerPublisher = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    let appState: AppState
    let favourites: Favourites
    
    @Published var searchTerm: String = "" {
        didSet {
            updateAttractions()
        }
    }
    
    // initialise parks data service
    init(parksDataService: ParksDataService = ParksDataService(),
         appState: AppState,
         favourites: Favourites) {
        self.parksDataService = parksDataService
        self.appState = appState
        self.favourites = favourites
        setupTimer()
        
        // Observe changes to favourites and update attractions
        favourites.$attractionIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateAttractions()
            }
            .store(in: &cancellables)
    }
    
    func fetchAttractionListData(parkId: String) {
        Task {
            do {
                let data = try await parksDataService.getAttractionData(parkId: parkId)
                DispatchQueue.main.async {
                    self.initialAttractionList = data
                    //self.loadFavouriteState()
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
    
    func setFilters(type: EntityType?, status: LiveStatus?) {
        currentType = type
        currentStatus = status
        updateAttractions()
    }
    
    private func updateAttractions() {
        var filtered = initialAttractionList

        if let type = currentType {
            filtered = filtered.filter { $0.entityType == type }
        }
        if let status = currentStatus {
            filtered = filtered.filter { $0.status == status }
        }
        if !searchTerm.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        }
        
        for index in filtered.indices {
            filtered[index].isFavourited = favourites.contains(filtered[index])
        }

        attractions = filtered
    }
    
    func toggleFavourite(attraction: Attraction) {
        print("Toggle favourites reached")
        if favourites.contains(attraction) {
            favourites.remove(attraction)
            
        } else {
            favourites.add(attraction)
        }
        updateAttractions()
    }
    
    // ATM favs are resetting when park is changed - need global fav list
//    private func saveFavouriteState() {
//        let favouriteIds = initialAttractionList.filter { $0.isFavourited }.map { $0.id }
//        UserDefaults.standard.set(favouriteIds, forKey: "favouriteAttractions")
//    }
//
//    private func loadFavouriteState() {
//        let favouriteIds = UserDefaults.standard.array(forKey: "favouriteAttractions") as? [String] ?? []
//        for index in initialAttractionList.indices {
//            initialAttractionList[index].isFavourited = favouriteIds.contains(initialAttractionList[index].id)
//        }
//        print("Loaded favourite state. Favourite IDs: \(favouriteIds)")
//    }
//    
//    func favouriteAttractions() {
//        self.loadFavouriteState()
//        print("Initial attractions:", initialAttractionList)
//        print("Attractions:", attractions)
//        let filteredAttractions = initialAttractionList.filter { $0.isFavourited }
//        print("Filtered attractions count: \(filteredAttractions.count)")
//        self.favAttractions = filteredAttractions
//    }
    
    func returnAllAttractions() {
        attractions = initialAttractionList
        print("Returning all attractions. Count: \(attractions.count)")
    }
}
