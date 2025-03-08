import Foundation

@MainActor
class HistoryManager: ObservableObject {
    @Published private(set) var history: [ConversionHistory] = []
    private let maxHistoryItems = 100
    private let userDefaults = UserDefaults.standard
    private let historyKey = "conversionHistory"
    
    init() {
        loadHistory()
    }
    
    func addConversion(category: String, inputValue: String, inputUnit: String, outputValue: String, outputUnit: String) {
        let conversion = ConversionHistory(
            category: category,
            inputValue: inputValue,
            inputUnit: inputUnit,
            outputValue: outputValue,
            outputUnit: outputUnit
        )
        
        history.insert(conversion, at: 0)
        
        // Keep only the most recent conversions
        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }
        
        saveHistory()
    }
    
    func clearHistory() {
        history.removeAll()
        saveHistory()
    }
    
    private func loadHistory() {
        guard let data = userDefaults.data(forKey: historyKey),
              let decodedHistory = try? JSONDecoder().decode([ConversionHistory].self, from: data) else {
            return
        }
        history = decodedHistory
    }
    
    private func saveHistory() {
        guard let encoded = try? JSONEncoder().encode(history) else {
            return
        }
        userDefaults.set(encoded, forKey: historyKey)
    }
} 