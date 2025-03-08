import Foundation

enum MeasurementSystem: String, CaseIterable {
    case metric = "Metric"
    case imperial = "Imperial/US"
    case imperialUK = "UK/Imperial"
    
    var icon: String {
        switch self {
        case .metric:
            return "ruler"
        case .imperial:
            return "ruler.fill"
        case .imperialUK:
            return "ruler.fill"
        }
    }
} 