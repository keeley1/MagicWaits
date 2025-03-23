import SwiftUI

struct DestinationListView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Magic Waits")
                    .font(.largeTitle)
                    .padding()
                Text("Destinations")
                    .font(.title)
                ScrollView {
                    ForEach(viewModel.destinations, id: \.id) { destination in
                        if destination.name.contains("Disneyland Resort") {
                            VStack {
                                Text(destination.name)
                                    .font(.headline)
                                ForEach(destination.parks, id: \.id) { park in
                                    NavigationLink(destination: AttractionListView(parkId: park.id).environmentObject(viewModel)) {
                                        Text(park.name)
                                            .font(.headline)
                                            .padding()
                                            .foregroundStyle(.white)
                                            .background(.pink)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchDestinationData()
                    } catch {
                        print("Could not fetch destination data")
                    }
                }
            }
        }
    }
}

#Preview {
    DestinationListView()
}
