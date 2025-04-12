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
 */
struct AttractionsListView: View {
    @StateObject private var viewModel = AttractionListViewModel()
    
    private let timerPublisher = Timer.publish(every: 300, on: .main, in: .common)
    @State private var cancellable: Cancellable?
    @State private var selectedAttraction: Attraction?
    @State private var searchTerm: String = ""
    @State private var isFilteredByStatus: Bool = false
    @State private var isFilteredByType: Bool = false
    
    var parkId: String
    var parkName: String

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                CustomToolbar(parkName: parkName)
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
            viewModel.fetchAttractionListData(parkId: parkId)
            
            cancellable = timerPublisher.connect()
        }
        .onReceive(timerPublisher.autoconnect()) { _ in
            viewModel.fetchAttractionListData(parkId: parkId)
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .sheet(item: $selectedAttraction) { attraction in
            AttractionDetailsView(attraction: attraction)
        }
    }

    private var attractionView: some View {
        ForEach(viewModel.attractions, id: \.id) { attraction in
            VStack(alignment: .leading) {
                HStack {
                    Text("**\(attraction.name)**")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        print("Button pressed")
                    }) {
                        Image(systemName: "heart")
                            .foregroundColor(Color("IconColor"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text(attraction.entityType.capitalizedEntityType)
                    Image(systemName: "circle.fill")
                        .font(.system(size: 5))
                    Text("Tomorrowland")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    if let waitTime = attraction.queue?.formattedQueue {
                        if waitTime != " " {
                            Text("**\(waitTime)**")
                                .foregroundColor(attraction.queueTextColor)
                                .padding(8)
                                .background(attraction.queueBackgroundColor)
                                .cornerRadius(8)
                        }
                    }
                    Text("**\(attraction.status.capitalizedStatus)**")
                        .foregroundColor(attraction.statusTextColor)
                        .padding(8)
                        .background(attraction.statusBackgroundColor)
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("SecondaryColor"))
            .cornerRadius(16)
            .padding(.vertical, 4)
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
            .background(Color.white)
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
    let colors = ["Red", "Green", "Blue", "Black", "Tartan"]

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
            
            Picker("Select a paint color", selection: $selection) {
                ForEach(colors, id: \.self) {
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
        AttractionsListView(parkId: "bfc89fd6-314d-44b4-b89e-df1a89cf991e", parkName: "Disneyland Park")
    }
}
