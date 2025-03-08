import Foundation

struct ConversionHistory: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let category: String
    let inputValue: String
    let inputUnit: String
    let outputValue: String
    let outputUnit: String
    
    init(category: String, inputValue: String, inputUnit: String, outputValue: String, outputUnit: String) {
        self.id = UUID()
        self.timestamp = Date()
        self.category = category
        self.inputValue = inputValue
        self.inputUnit = inputUnit
        self.outputValue = outputValue
        self.outputUnit = outputUnit
    }
} 