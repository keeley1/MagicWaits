import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var attractions: [Attraction] = []
    private var cancellable: AnyCancellable?
    
    @Published var destinations: [Destination] = []

    func fetchParkData(id: String) async throws {
        let url = URL(string: "https://api.themeparks.wiki/v1/entity/\(id)/live")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(DisneylandData.self, from: data)
        
        print("Data retrieved: \(decoded.liveData)")
        DispatchQueue.main.async {
            self.attractions = decoded.liveData
        }
    }
    
    func fetchDestinationData() async throws {
        let url = URL(string: "https://api.themeparks.wiki/v1/destinations")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            do {
                let decodedResponse = try JSONDecoder().decode([String: [Destination]].self, from: data)
                if let decoded = decodedResponse["destinations"] {
                    print("Data retrieved: \(decoded)")
                    DispatchQueue.main.async {
                        self.destinations = decoded
                    }
                } else {
                    print("No destinations found in response")
                }
            } catch {
                print("Error decoding data: \(error)")
                throw error
            }
        } catch {
            print("Error fetching data: \(error)")
            throw error
        }
    }
}
