import SwiftUI
import Combine

struct FavouriteAttractionsView: View {
    @ObservedObject var viewModel: AttractionListViewModel
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
        }
        .sheet(item: $selectedAttraction) { attraction in
            AttractionDetailsView(attraction: attraction)
        }
    }

    private var attractionView: some View {
        ForEach(viewModel.attractions.filter { viewModel.favourites.contains($0) }, id: \.id) { attraction in
            AttractionView(attraction: attraction, viewModel: viewModel)
                .onTapGesture {
                    selectedAttraction = attraction
                }
        }
    }
}

// Consider alternative methods - view model factory etc
struct FavouriteAttractionsViewContainer: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var favourites: Favourites
    @StateObject private var viewModel: AttractionListViewModel

    init() {
        _viewModel = StateObject(wrappedValue: AttractionListViewModel(appState: AppState(), favourites: Favourites()))
    }

    var body: some View {
        FavouriteAttractionsView(viewModel: viewModel)
    }
}

#Preview {
    FavouriteAttractionsViewContainer()
        .environmentObject(AppState())
        .environmentObject(Favourites())
}
