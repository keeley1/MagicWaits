import Foundation
import SwiftUICore

extension Attraction {
    var statusTextColor: Color {
        switch status {
        case .operating:
            return Color(hex: "059669")
        case .down:
            return Color(hex: "D97706")
        case .closed:
            return Color(hex: "B60000")
        case .refurbishment:
            return Color(hex: "0056C7")
        }
    }
    
    var statusBackgroundColor: Color {
        switch status {
        case .operating:
            return Color(hex: "D1FAE5")
        case .down:
            return Color(hex: "FEF3C7")
        case .closed:
            return Color(hex: "FFDADA")
        case .refurbishment:
            return Color(hex: "CDE3FF")
        }
    }
}
