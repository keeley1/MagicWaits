import Foundation

class ParksDataService {
    // review function:
    func getParksData() async throws -> [Destination] {
        let url = URL(string: "https://api.themeparks.wiki/v1/destinations")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode([String: [Destination]].self, from: data)

        guard let destinations = decodedResponse["destinations"] else {
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "No destinations found in response"])
        }
        return destinations
    }
    
    func getAttractionData(parkId: String) async throws -> [Attraction] {
        let url = URL(string: "https://api.themeparks.wiki/v1/entity/\(parkId)/live")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(DisneylandData.self, from: data)

        // further filter to display with wait times first - should this be here or view model?
        let filteredData = decoded.liveData.filter { $0.entityType == .attraction || $0.entityType == .show }
        
        for data in filteredData {
            if data.entityType == .attraction {
                print("attraction name: ", data.name)
            }
        }
        return filteredData
    }
}
