
import Foundation

extension Date {
    static func getCurrentTime() -> String{
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
