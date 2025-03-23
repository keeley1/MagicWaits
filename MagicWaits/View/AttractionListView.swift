import SwiftUI

struct AttractionListView: View {
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var attractionListViewModel = AttractionListViewModel()
    var parkId: String

    var body: some View {
        Text("Attractions")
            .font(.largeTitle)
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        Text("Search")
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Text("Filter")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Spacer()
                }
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
                                Text("\(attraction.status.rawValue)")
                                    .font(.subheadline)
                                    .foregroundStyle(attraction.status.rawValue.contains("OPERATING") ? .green : .red)
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
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
            }
            .frame(maxWidth: 600)
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchParkData(id: parkId)
                    
                    // test filtering
                    viewModel.attractions = attractionListViewModel.filterAttractionByStatus(attractions: viewModel.attractions, status: .refurbishment)
                } catch {
                    print("Failed to fetch data: \(error)")
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AttractionListView(parkId: "bfc89fd6-314d-44b4-b89e-df1a89cf991e")
}
