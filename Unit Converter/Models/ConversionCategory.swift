import Foundation

struct ConversionCategory: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let units: [UnitType]
    
    static func == (lhs: ConversionCategory, rhs: ConversionCategory) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Convenience initializer with auto-generated ID
    init(name: String, icon: String, units: [UnitType]) {
        self.id = UUID().uuidString
        self.name = name
        self.icon = icon
        self.units = units
    }
} 