import SwiftUI

struct NavbarView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: AttractionListViewModel
    
    // TODO - Display park name dynamically
    var parkName: String
    
    @State private var selection = ParkIdentifiers.disneylandParkId
    let parks = ["Both parks": ParkIdentifiers.bothParksId,
                 ParkIdentifiers.disneylandPark: ParkIdentifiers.disneylandParkId,
                 ParkIdentifiers.californiaAdventurePark: ParkIdentifiers.californiaAdventureParkId]
    
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
            
            Picker("", selection: $selection) {
                ForEach(Array(parks), id: \.key) { key, value in
                    Text(key).tag(value)
                }
            }
            .pickerStyle(.menu)
            .padding(.horizontal)
            .tint(.white)
            .onChange(of: selection) {
                print("Selected park: \(selection)")
                print("App state:", appState.currentParkId)
                appState.currentParkId = selection
                print("App state:", appState.currentParkId)
                viewModel.fetchAttractionListData(parkId: appState.currentParkId)
                viewModel.returnAllAttractions()
            }
            
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
    let appState = AppState()
    let viewModel = AttractionListViewModel(appState: appState)
    NavbarView(viewModel: viewModel, parkName: "Disneyland Park")
        .environmentObject(appState)
}
