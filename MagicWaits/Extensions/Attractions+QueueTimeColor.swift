import Foundation
import SwiftUICore

extension Attraction {
    var queueTextColor: Color {
        let waitTime = queue?.standby?.waitTime ?? 0
        
        if waitTime <= 30 {
            return Color("AttractionGreenTextColor")
        } else if waitTime <= 55 {
            return Color("AttractionOrangeTextColor")
        } else {
            return Color("AttractionRedTextColor")
        }
    }
    
    var queueBackgroundColor: Color {
        let waitTime = queue?.standby?.waitTime ?? 0
        
        if waitTime <= 30 {
            return Color("AttractionGreenBackgroundColor")
        } else if waitTime <= 55 {
            return Color("AttractionOrangeBackgroundColor")
        } else {
            return Color("AttractionRedBackgroundColor")
        }
    }
}
