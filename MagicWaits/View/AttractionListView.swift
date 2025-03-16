import SwiftUI

struct AttractionListView: View {
    @StateObject private var viewModel = ContentViewModel()
    var parkId: String
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.attractions, id: \.id) { attraction in
                    VStack {
                        Text(attraction.name)
                            .font(.headline)
                        HStack {
                            Text("Type: \(attraction.entityType)")
                                .font(.subheadline)
                            HStack {
                                Text("Status:")
                                    .font(.subheadline)
                                Text("\(attraction.status)")
                                    .font(.subheadline)
                                    .foregroundStyle(attraction.status.contains("OPERATING") ? .green : .red)
                            }
                        }
                        HStack {
                            Text("Wait time:")
                            if let waitTime = attraction.queue?.formattedQueue {
                                if waitTime != " " {
                                    Text("\(waitTime)")
                                } else {
                                    Text("N/A")
                                }
                            } else {
                                Text("N/A")
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchParkData(id: parkId)
                } catch {
                    print("Failed to fetch data: \(error)")
                }
            }
        }
    }
}

#Preview {
    AttractionListView(parkId: "bfc89fd6-314d-44b4-b89e-df1a89cf991e")
}
