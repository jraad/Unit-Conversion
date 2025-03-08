import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyManager: HistoryManager
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(historyManager.history) { conversion in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(conversion.category)
                                .font(.headline)
                            Spacer()
                            Text(dateFormatter.string(from: conversion.timestamp))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("\(conversion.inputValue) \(conversion.inputUnit)")
                            Image(systemName: "arrow.right")
                                .foregroundColor(.secondary)
                            Text("\(conversion.outputValue) \(conversion.outputUnit)")
                                .foregroundColor(Color.Custom.resultText)
                        }
                        .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        historyManager.clearHistory()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
} 