import SwiftUI

struct SelectParkView: View {
    @StateObject private var viewModel = SelectParkViewModel()
    
    //MARK: - review centering
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.indigo, .purple]), startPoint: .trailing, endPoint: .leading)
                    .ignoresSafeArea()
                VStack {
                    selectParkHeaderView
                    // selectIndividualParkView
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.getParkList()
                    } catch {
                        print("Could not fetch destination data")
                    }
                }
            }
        }
    }
    
    private var selectParkHeaderView: some View {
        VStack {
            Text("**MagicWaits**")
                .font(.largeTitle)
                .foregroundStyle(.white)
            Text("Choose your destination")
                .foregroundStyle(.white)
        }
        .padding()
    }
    
//    private var selectIndividualParkView: some View {
//        HStack {
//            ForEach(viewModel.destinations, id: \.id) { destination in
//                if destination.name.contains("Disneyland Resort") {
//                    ForEach(destination.parks, id: \.id) { park in
//                        NavigationLink(destination: AttractionsListView(parkId: park.id, parkName: park.name).environmentObject(viewModel)) {
//                            VStack {
//                                if park.name.contains("Disneyland") {
//                                    Image("SelectParkDisneyland")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 100, height: 100)
//                                        .clipped()
//                                        .cornerRadius(16)
//                                } else {
//                                    Image("SelectParkDCA")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 100, height: 100)
//                                        .clipped()
//                                        .cornerRadius(16)
//                                }
//                                Text(park.name)
//                                    .foregroundStyle(.white)
//                                    .frame(height: 50)
//                                    .multilineTextAlignment(.center)
//                            }
//                            .frame(width: 160, height: 200)
//                            .background(.indigo.opacity(0.3))
//                            .cornerRadius(16)
//                            .padding(8)
//                        }
//                    }
//                }
//            }
//        }
//    }
}

#Preview {
    SelectParkView()
}
