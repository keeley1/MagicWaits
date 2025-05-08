import SwiftUI
import Combine

// possibly find thrill level etc, look at figma designs
// colour theme include in more places

/*
 To do
 - check how vars are being passed
 - check how api call data is being stored,
    what is the ideal way to do that
 - Look into how to filter/search
 - Should custom toolbar be in this file
 - review how api should be called
 - sort by land, park, thrill?
 - make navbar at top app colours????
 - should app title be visible on this page?
 - fix padding on filters
 - add filter button that can hide filters
 - add constants for corner radius, etc
 - test what happens to filter, search when api is called
 - check search + style search bar
 - should this page have a back button (to selection) or select park button
 - Make this screen the main home screen
 - Need to check data refreshing
 - Get favouriting working
 - Get swap parks working
 */
struct AttractionsListView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AttractionListViewModel(appState: AppState())
    
    @State private var selectedAttraction: Attraction?
    @State private var searchTerm: String = ""
    @State private var isFilteredByStatus: Bool = false
    @State private var isFilteredByType: Bool = false

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                CustomToolbar(parkName: "Disneyland Park")
                ScrollView {
                    VStack {
                        searchview
                        filterAttractionsView
                        attractionView
                            .padding(.horizontal, 16)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
        .onAppear {
            viewModel.fetchAttractionListData(parkId: appState.currentParkId)
            // cancellable = timerPublisher.connect()
        }
        .sheet(item: $selectedAttraction) { attraction in
            AttractionDetailsView(attraction: attraction)
        }
    }
    
    private var attractionView: some View {
        ForEach(viewModel.attractions, id: \.id) { attraction in
            AttractionView(attraction: attraction, viewModel: viewModel)
                .onTapGesture {
                    selectedAttraction = attraction
                }
        }
    }

    private var searchview: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("IconColor"), lineWidth: 1)
                TextField("Search attractions", text: $searchTerm)
                    .padding(8)
            }
            .background(Color("SecondaryColor"))
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom, 8)
    }
    
    private var filterAttractionsView: some View {
        HStack {
            Text("Filters")
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button(action: {
                        if isFilteredByType {
                            viewModel.filterAttractions(byType: nil, andStatus: isFilteredByStatus ? .operating : nil)
                        } else {
                            viewModel.filterAttractions(byType: .attraction, andStatus: isFilteredByStatus ? .operating : nil)
                        }
                        isFilteredByType.toggle()
                    }) {
                        Text("Attractions")
                    }
                    .foregroundStyle(Color("IconColor"))
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isFilteredByType ? Color("PurpleGradientColor") : Color("FilterButtonColor"))
                    )
                    
                    // Status Filter Button
                    Button(action: {
                        if isFilteredByStatus {
                            viewModel.filterAttractions(byType: isFilteredByType ? .attraction : nil, andStatus: nil)
                        } else {
                            viewModel.filterAttractions(byType: isFilteredByType ? .attraction : nil, andStatus: .operating)
                        }
                        isFilteredByStatus.toggle()
                    }) {
                        Text("Operating")
                    }
                    .foregroundStyle(Color("IconColor"))
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isFilteredByStatus ? Color("PurpleGradientColor") : Color("FilterButtonColor"))
                    )
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(width: 250)
        }
        .padding(.horizontal)
    }
}

struct CustomToolbar: View {
    var parkName: String
    
    @State private var selection = "Red"
    let parks = ["Disneyland Park", "Disney California Adventure Park", "Both parks"]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("**\(parkName)**")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Spacer()
                Button(action: {
                    print("Button pressed")
                }) {
                    Image(systemName: "moon.fill")
                        .foregroundStyle(Color("IconColor"))
                }
            }
            .padding(.horizontal)
            
            Picker("Select a park", selection: $selection) {
                ForEach(parks, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            .foregroundStyle(.white)
            .padding(.horizontal)
            
            Spacer()
                .frame(height: 16)
        }
        .background {
            LinearGradient(gradient: Gradient(colors: [Color("IndigoGradientColor"), Color("PurpleGradientColor")]), startPoint: .trailing, endPoint: .leading)
                .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    NavigationView {
        AttractionsListView()
    }
}
