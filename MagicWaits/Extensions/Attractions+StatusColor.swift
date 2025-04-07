import Foundation
import SwiftUICore

extension Attraction {
    var statusTextColor: Color {
        switch status {
        case .operating:
            return Color("AttractionGreenTextColor")
        case .down:
            return Color("AttractionOrangeTextColor")
        case .closed:
            return Color("AttractionRedTextColor")
        case .refurbishment:
            return Color("AttractionRefurbishmentTextColor")
        }
    }
    
    var statusBackgroundColor: Color {
        switch status {
        case .operating:
            return Color("AttractionGreenBackgroundColor")
        case .down:
            return Color("AttractionOrangeBackgroundColor")
        case .closed:
            return Color("AttractionRedBackgroundColor")
        case .refurbishment:
            return Color("AttractionRefurbishmentBackgroundColor")
        }
    }
}
