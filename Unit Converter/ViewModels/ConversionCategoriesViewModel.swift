import Foundation
import SwiftUI

@MainActor
class ConversionCategoriesViewModel: ObservableObject {
    @Published private(set) var categories: [ConversionCategory] = []
    
    init() {
        setupCategories()
    }
    
    private func setupCategories() {
        categories = [
            // Length
            ConversionCategory(
                name: "Length",
                icon: "ruler",
                units: [
                    UnitType(name: "Millimeter", symbol: "mm", system: .metric),
                    UnitType(name: "Centimeter", symbol: "cm", system: .metric),
                    UnitType(name: "Meter", symbol: "m", system: .metric),
                    UnitType(name: "Kilometer", symbol: "km", system: .metric),
                    UnitType(name: "Inch", symbol: "in", system: .imperial),
                    UnitType(name: "Foot", symbol: "ft", system: .imperial),
                    UnitType(name: "Yard", symbol: "yd", system: .imperial),
                    UnitType(name: "Mile", symbol: "mi", system: .imperial)
                ]
            ),
            
            // Weight/Mass
            ConversionCategory(
                name: "Weight",
                icon: "scalemass",
                units: [
                    UnitType(name: "Milligram", symbol: "mg", system: .metric),
                    UnitType(name: "Gram", symbol: "g", system: .metric),
                    UnitType(name: "Kilogram", symbol: "kg", system: .metric),
                    UnitType(name: "Metric Ton", symbol: "t", system: .metric),
                    UnitType(name: "Ounce", symbol: "oz", system: .imperial),
                    UnitType(name: "Pound", symbol: "lb", system: .imperial),
                    UnitType(name: "Stone", symbol: "st", system: .imperial),
                    UnitType(name: "US Ton", symbol: "ton", system: .imperial)
                ]
            ),
            
            // Volume
            ConversionCategory(
                name: "Volume",
                icon: "beaker",
                units: [
                    // Metric
                    UnitType(name: "Milliliter", symbol: "ml", system: .metric),
                    UnitType(name: "Centiliter", symbol: "cl", system: .metric),
                    UnitType(name: "Deciliter", symbol: "dl", system: .metric),
                    UnitType(name: "Liter", symbol: "l", system: .metric),
                    UnitType(name: "Cubic Meter", symbol: "m³", system: .metric),
                    // US Cooking
                    UnitType(name: "Teaspoon", symbol: "tsp", system: .imperial),
                    UnitType(name: "Tablespoon", symbol: "tbsp", system: .imperial),
                    UnitType(name: "Fluid Ounce", symbol: "fl oz", system: .imperial),
                    UnitType(name: "Cup", symbol: "cup", system: .imperial),
                    UnitType(name: "Pint", symbol: "pt", system: .imperial),
                    UnitType(name: "Quart", symbol: "qt", system: .imperial),
                    UnitType(name: "Gallon", symbol: "gal", system: .imperial),
                    // UK/Imperial
                    UnitType(name: "Imperial Cup", symbol: "cup (UK)", system: .imperialUK),
                    UnitType(name: "Imperial Pint", symbol: "pt (UK)", system: .imperialUK),
                    UnitType(name: "Imperial Quart", symbol: "qt (UK)", system: .imperialUK),
                    UnitType(name: "Imperial Gallon", symbol: "gal (UK)", system: .imperialUK)
                ]
            ),
            
            // Temperature
            ConversionCategory(
                name: "Temperature",
                icon: "thermometer",
                units: [
                    UnitType(name: "Celsius", symbol: "°C", system: .metric),
                    UnitType(name: "Fahrenheit", symbol: "°F", system: .imperial),
                    UnitType(name: "Kelvin", symbol: "K", system: .metric)
                ]
            ),
            
            // Area
            ConversionCategory(
                name: "Area",
                icon: "square",
                units: [
                    UnitType(name: "Square Meter", symbol: "m²", system: .metric),
                    UnitType(name: "Hectare", symbol: "ha", system: .metric),
                    UnitType(name: "Square Kilometer", symbol: "km²", system: .metric),
                    UnitType(name: "Square Foot", symbol: "ft²", system: .imperial),
                    UnitType(name: "Square Yard", symbol: "yd²", system: .imperial),
                    UnitType(name: "Acre", symbol: "ac", system: .imperial),
                    UnitType(name: "Square Mile", symbol: "mi²", system: .imperial)
                ]
            ),
            
            // Speed
            ConversionCategory(
                name: "Speed",
                icon: "speedometer",
                units: [
                    UnitType(name: "Kilometers per Hour", symbol: "km/h", system: .metric),
                    UnitType(name: "Meters per Second", symbol: "m/s", system: .metric),
                    UnitType(name: "Miles per Hour", symbol: "mph", system: .imperial),
                    UnitType(name: "Knots", symbol: "kn", system: .imperial)
                ]
            )
        ]
    }
} 