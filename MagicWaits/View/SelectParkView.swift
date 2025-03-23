import SwiftUI

struct SelectParkView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    //MARK: - review centering
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.indigo, .purple]), startPoint: .trailing, endPoint: .leading)
                    )
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Text("MagicWaits")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        Text("Choose your destination")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    HStack {
                        ForEach(viewModel.destinations, id: \.id) { destination in
                            if destination.name.contains("Disneyland Resort") {
                                ForEach(destination.parks, id: \.id) { park in
                                    NavigationLink(destination: AttractionListView(parkId: park.id).environmentObject(viewModel)) {
                                        VStack {
                                            Text("Image")
                                                .frame(width: 100, height: 100)
                                                .background(.blue)
                                            Text(park.name)
                                                .foregroundStyle(.white)
                                                .frame(height: 50)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 160, height: 200)
                                        .background(.indigo.opacity(0.3))
                                        .cornerRadius(16)
                                        .padding(8)
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
    SelectParkView()
}
