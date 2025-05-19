import SwiftUI
import Combine

struct FavouriteAttractionsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AttractionListViewModel(appState: AppState())
    
    private let timerPublisher = Timer.publish(every: 300, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    @State private var selectedAttraction: Attraction?
    @State private var searchTerm: String = ""
    @State private var isFilteredByStatus: Bool = false
    @State private var isFilteredByType: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                NavbarView(viewModel: viewModel, parkName: "Disneyland Park")
                ScrollView {
                    VStack {
                        attractionView
                            .padding(.horizontal, 16)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
        .onAppear {
            viewModel.fetchAttractionListData(parkId: ParkIdentifiers.bothParksId)
            viewModel.favouriteAttractions()
        }
        .sheet(item: $selectedAttraction) { attraction in
            AttractionDetailsView(attraction: attraction)
        }
    }
    
    private var attractionView: some View {
        ForEach(viewModel.favAttractions, id: \.id) { attraction in
            AttractionView(attraction: attraction, viewModel: viewModel)
                .onTapGesture {
                    selectedAttraction = attraction
                }
        }
    }
}

#Preview {
    FavouriteAttractionsView()
}
