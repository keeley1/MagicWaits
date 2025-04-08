import Foundation

class ParksDataService {
    // review function:
    func getParksData() async throws -> [Destination] {
        let url = URL(string: "https://api.themeparks.wiki/v1/destinations")!
        let parksData: [Destination] = []

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            do {
                let decodedResponse = try JSONDecoder().decode([String: [Destination]].self, from: data)
                if let decoded = decodedResponse["destinations"] {
                    return decoded
                } else {
                    print("No destinations found in response")
                    return parksData
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
        
        // fetch image URL for each attraction
        
        return filteredData
    }
}
