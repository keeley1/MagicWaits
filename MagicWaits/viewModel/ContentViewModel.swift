import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var attractions: [Attraction] = []
    private var cancellable: AnyCancellable?

    func fetchDisneylandData() async throws {
        let url = URL(string: "https://api.themeparks.wiki/v1/entity/7340550b-c14d-4def-80bb-acdb51d49a66/live")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(DisneylandData.self, from: data)
        
        print("Data retrieved: \(decoded.liveData)")
        DispatchQueue.main.async {
            self.attractions = decoded.liveData
        }
    }
}
