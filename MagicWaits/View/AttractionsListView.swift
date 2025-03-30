import SwiftUI
import Combine

// possibly find thrill level etc, look at figma designs
// colour theme include in more places

struct AttractionsListView: View {
    @StateObject private var viewModel = AttractionListViewModel()
    
    private let timerPublisher = Timer.publish(every: 300, on: .main, in: .common)
    @State private var cancellable: Cancellable?

    var parkId: String
    var parkName: String

    var body: some View {
        ZStack {
            Color(hex: "E5E7EB")
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                CustomToolbar(parkName: parkName)
                ScrollView {
                    VStack {
                        searchview
                            .padding(.horizontal, 16)
                        attractionView
                            .padding(.horizontal, 16)
                    }
                }
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
    }

    private var attractionView: some View {
        ForEach(viewModel.attractions, id: \.id) { attraction in
            NavigationLink(destination: AttractionDetailsView(attractionName: attraction.name)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(attraction.name)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(action: {
                            print("Button pressed")
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text(attraction.entityType.capitalizedEntityType)
                            .foregroundColor(.black)
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                            .foregroundColor(.black)
                        Text("Tomorrowland")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        if let waitTime = attraction.queue?.formattedQueue {
                            if waitTime != " " {
                                Text("\(waitTime) min")
                                    .foregroundColor(attraction.queueTextColor)
                                    .padding(8)
                                    .background(attraction.queueBackgroundColor)
                                    .cornerRadius(8)
                            }
                        }
                        Text(attraction.status.capitalizedStatus)
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
                .background(Color.white)
                .cornerRadius(16)
                .padding(.vertical, 4)
            }
        }
    }

    private var searchview: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.black)
            Text("Search attractions")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundStyle(.black)
        .background(Color.white)
        .clipShape(.capsule)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.gray, lineWidth: 1)
        )
        .background(Color(hex: "E5E7EB"))
        .padding(.top, 16)
    }
}

struct CustomToolbar: View {
    var parkName: String

    var body: some View {
        VStack {
            HStack {
                Text("**\(parkName)**")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    print("Button pressed")
                }) {
                    Image(systemName: "moon.fill")
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal)
            Spacer()
                .frame(height: 16)
        }
        .background(Color(hex: "E5E7EB"))
    }
}

#Preview {
    NavigationView {
        AttractionsListView(parkId: "bfc89fd6-314d-44b4-b89e-df1a89cf991e", parkName: "Disneyland Park")
    }
}
