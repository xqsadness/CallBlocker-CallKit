import Foundation
extension TimeInterval {
    func convertToString() -> String{
        if self.isInfinite || self.isNaN{
            return ""
        }
        switch self{
        case 60..<3600:
            return self.hourMinuteSecond
        case 1..<60:
            return self.minuteSecond
        case 0..<1:
            return self.secondMS
        default:
            return self.hourMinuteSecond
        }
    }
    var hourMinuteString: String{
        String(format:"%d:%02d", hour, minute)
    }
    var hourMinuteSecond: String {
        String(format:"%d:%02d:%02d", hour, minute, second)
    }
    var minuteSecond: String {
        String(format:"%d:%02d", minute, second)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d:%03d", minute, second, millisecond)
    }
    var secondMS: String {
        String(format:"%02d:%03d", second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
