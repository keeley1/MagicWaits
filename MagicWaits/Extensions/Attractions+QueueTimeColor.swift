import Foundation
import SwiftUICore

extension Attraction {
    var queueTextColor: Color {
        let waitTime = queue?.standby?.waitTime ?? 0
        
        if waitTime <= 30 {
            return Color(hex: "059669")
        } else if waitTime <= 55 {
            return Color(hex: "D97706")
        } else {
            return Color(hex: "B60000")
        }
    }
    
    var queueBackgroundColor: Color {
        let waitTime = queue?.standby?.waitTime ?? 0
        
        if waitTime <= 30 {
            return Color(hex: "D1FAE5")
        } else if waitTime <= 55 {
            return Color(hex: "FEF3C7")
        } else {
            return Color(hex: "FFDADA")
        }
    }
}
