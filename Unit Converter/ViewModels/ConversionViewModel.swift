import Foundation

@MainActor
class ConversionViewModel: ObservableObject {
    let category: ConversionCategory
    
    @Published var inputValue: String = ""
    @Published var inputUnit: UnitType
    @Published var outputUnit: UnitType
    @Published private(set) var result: String = ""
    @Published private(set) var error: String?
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    var groupedUnits: [(String, [UnitType])] {
        Dictionary(grouping: category.units) { unit in
            unit.system.rawValue
        }
        .sorted { $0.key < $1.key }
    }
    
    init(category: ConversionCategory, initialInputUnit: UnitType, initialOutputUnit: UnitType) {
        self.category = category
        self.inputUnit = initialInputUnit
        self.outputUnit = initialOutputUnit
    }
    
    func convert() {
        guard let inputNumber = Double(inputValue.replacingOccurrences(of: ",", with: ".")) else {
            error = "Please enter a valid number"
            result = ""
            return
        }
        
        do {
            let convertedValue = try performConversion(value: inputNumber)
            error = nil
            result = formatResult(convertedValue)
        } catch {
            self.error = error.localizedDescription
            result = ""
        }
    }
    
    private func formatResult(_ value: Double) -> String {
        if abs(value) < 0.000001 && value != 0 {
            return String(format: "%.8e", value)
        }
        return numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    private func performConversion(value: Double) throws -> Double {
        switch category.name {
        case "Length":
            return try convertLength(value)
        case "Weight":
            return try convertWeight(value)
        case "Volume":
            return try convertVolume(value)
        case "Temperature":
            return try convertTemperature(value)
        case "Area":
            return try convertArea(value)
        case "Speed":
            return try convertSpeed(value)
        default:
            throw ConversionError.unsupportedCategory
        }
    }
    
    private func convertLength(_ value: Double) throws -> Double {
        let measurement = Measurement(value: value, unit: lengthUnit(for: inputUnit))
        return measurement.converted(to: lengthUnit(for: outputUnit)).value
    }
    
    private func convertWeight(_ value: Double) throws -> Double {
        let measurement = Measurement(value: value, unit: massUnit(for: inputUnit))
        return measurement.converted(to: massUnit(for: outputUnit)).value
    }
    
    private func convertVolume(_ value: Double) throws -> Double {
        // Handle UK/Imperial conversions separately
        if inputUnit.system == .imperialUK || outputUnit.system == .imperialUK {
            return try convertVolumeWithImperial(value)
        }
        
        let measurement = Measurement(value: value, unit: volumeUnit(for: inputUnit))
        return measurement.converted(to: volumeUnit(for: outputUnit)).value
    }
    
    private func convertVolumeWithImperial(_ value: Double) throws -> Double {
        // Convert to milliliters first as a common unit
        let mlValue: Double
        
        // Convert input to milliliters
        switch inputUnit.symbol {
        case "ml": mlValue = value
        case "cl": mlValue = value * 10
        case "dl": mlValue = value * 100
        case "l": mlValue = value * 1000
        case "m³": mlValue = value * 1_000_000
        case "tsp": mlValue = value * 4.92892
        case "tbsp": mlValue = value * 14.7868
        case "fl oz": mlValue = value * 29.5735
        case "cup": mlValue = value * 236.588
        case "pt": mlValue = value * 473.176
        case "qt": mlValue = value * 946.353
        case "gal": mlValue = value * 3785.41
        case "cup (UK)": mlValue = value * 284.131
        case "pt (UK)": mlValue = value * 568.261
        case "qt (UK)": mlValue = value * 1136.52
        case "gal (UK)": mlValue = value * 4546.09
        default: throw ConversionError.unsupportedConversion
        }
        
        // Convert milliliters to output unit
        switch outputUnit.symbol {
        case "ml": return mlValue
        case "cl": return mlValue / 10
        case "dl": return mlValue / 100
        case "l": return mlValue / 1000
        case "m³": return mlValue / 1_000_000
        case "tsp": return mlValue / 4.92892
        case "tbsp": return mlValue / 14.7868
        case "fl oz": return mlValue / 29.5735
        case "cup": return mlValue / 236.588
        case "pt": return mlValue / 473.176
        case "qt": return mlValue / 946.353
        case "gal": return mlValue / 3785.41
        case "cup (UK)": return mlValue / 284.131
        case "pt (UK)": return mlValue / 568.261
        case "qt (UK)": return mlValue / 1136.52
        case "gal (UK)": return mlValue / 4546.09
        default: throw ConversionError.unsupportedConversion
        }
    }
    
    private func convertTemperature(_ value: Double) throws -> Double {
        switch (inputUnit.symbol, outputUnit.symbol) {
        case ("°C", "°F"):
            return value * 9/5 + 32
        case ("°C", "K"):
            return value + 273.15
        case ("°F", "°C"):
            return (value - 32) * 5/9
        case ("°F", "K"):
            return (value - 32) * 5/9 + 273.15
        case ("K", "°C"):
            return value - 273.15
        case ("K", "°F"):
            return (value - 273.15) * 9/5 + 32
        case (let from, let to) where from == to:
            return value
        default:
            throw ConversionError.unsupportedConversion
        }
    }
    
    private func convertArea(_ value: Double) throws -> Double {
        let measurement = Measurement(value: value, unit: areaUnit(for: inputUnit))
        return measurement.converted(to: areaUnit(for: outputUnit)).value
    }
    
    private func convertSpeed(_ value: Double) throws -> Double {
        let measurement = Measurement(value: value, unit: speedUnit(for: inputUnit))
        return measurement.converted(to: speedUnit(for: outputUnit)).value
    }
    
    // MARK: - Unit Mappings
    
    private func lengthUnit(for unit: UnitType) -> UnitLength {
        switch unit.symbol {
        case "mm": return .millimeters
        case "cm": return .centimeters
        case "m": return .meters
        case "km": return .kilometers
        case "in": return .inches
        case "ft": return .feet
        case "yd": return .yards
        case "mi": return .miles
        default: return .meters
        }
    }
    
    private func massUnit(for unit: UnitType) -> UnitMass {
        switch unit.symbol {
        case "mg": return .milligrams
        case "g": return .grams
        case "kg": return .kilograms
        case "t": return .metricTons
        case "oz": return .ounces
        case "lb": return .pounds
        case "st": return .stones
        case "ton": return .shortTons
        default: return .kilograms
        }
    }
    
    private func volumeUnit(for unit: UnitType) -> UnitVolume {
        switch unit.symbol {
        case "ml": return .milliliters
        case "cl": return .milliliters
        case "dl": return .milliliters
        case "l": return .liters
        case "m³": return .cubicMeters
        case "tsp": return .teaspoons
        case "tbsp": return .tablespoons
        case "fl oz": return .fluidOunces
        case "cup": return .cups
        case "pt": return .pints
        case "qt": return .quarts
        case "gal": return .gallons
        // UK units will be handled by convertVolumeWithImperial
        case "cup (UK)", "pt (UK)", "qt (UK)", "gal (UK)":
            return .milliliters
        default: return .liters
        }
    }
    
    private func areaUnit(for unit: UnitType) -> UnitArea {
        switch unit.symbol {
        case "m²": return .squareMeters
        case "ha": return .hectares
        case "km²": return .squareKilometers
        case "ft²": return .squareFeet
        case "yd²": return .squareYards
        case "ac": return .acres
        case "mi²": return .squareMiles
        default: return .squareMeters
        }
    }
    
    private func speedUnit(for unit: UnitType) -> UnitSpeed {
        switch unit.symbol {
        case "km/h": return .kilometersPerHour
        case "m/s": return .metersPerSecond
        case "mph": return .milesPerHour
        case "kn": return .knots
        default: return .metersPerSecond
        }
    }
}

// MARK: - Errors

enum ConversionError: LocalizedError {
    case unsupportedCategory
    case unsupportedConversion
    case invalidInput
    
    var errorDescription: String? {
        switch self {
        case .unsupportedCategory:
            return "This category is not supported"
        case .unsupportedConversion:
            return "This conversion is not supported"
        case .invalidInput:
            return "Invalid input value"
        }
    }
} 