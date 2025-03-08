import Foundation

struct UnitType: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let system: MeasurementSystem
    
    static func == (lhs: UnitType, rhs: UnitType) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Convenience initializer with auto-generated ID
    init(name: String, symbol: String, system: MeasurementSystem) {
        self.id = UUID().uuidString
        self.name = name
        self.symbol = symbol
        self.system = system
    }
    
    // Display name combining name and symbol
    var displayName: String {
        "\(name) (\(symbol))"
    }
} 