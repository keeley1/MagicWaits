import Foundation

final class AppState: ObservableObject {
    @Published var currentParkId: String = ParkIdentifiers.disneylandParkId
}
