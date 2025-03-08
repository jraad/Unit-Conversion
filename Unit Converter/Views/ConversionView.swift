import SwiftUI

struct ConversionView: View {
    @StateObject private var viewModel: ConversionViewModel
    @ObservedObject var historyManager: HistoryManager
    @State private var showCopiedFeedback = false
    @State private var showHistory = false
    
    init(category: ConversionCategory, historyManager: HistoryManager) {
        let initialInputUnit = category.units[0]
        let initialOutputUnit = category.units.count > 1 ? category.units[1] : category.units[0]
        _viewModel = StateObject(wrappedValue: ConversionViewModel(
            category: category,
            initialInputUnit: initialInputUnit,
            initialOutputUnit: initialOutputUnit
        ))
        self.historyManager = historyManager
    }
    
    var body: some View {
        Form {
            Section("Input") {
                TextField("Value", text: $viewModel.inputValue)
                    .keyboardType(.decimalPad)
                    .onChange(of: viewModel.inputValue) { viewModel.convert() }
                
                Picker("From", selection: $viewModel.inputUnit) {
                    ForEach(viewModel.groupedUnits, id: \.0) { group, units in
                        Section(group) {
                            ForEach(units) { unit in
                                Text(unit.displayName).tag(unit)
                            }
                        }
                    }
                }
                .onChange(of: viewModel.inputUnit) { 
                    HapticManager.selection()
                    viewModel.convert()
                }
            }
            
            Section {
                Button(action: {
                    HapticManager.impact(style: .medium)
                    swapUnits()
                }) {
                    Label("Swap Units", systemImage: "arrow.up.arrow.down")
                        .foregroundColor(Color.Custom.resultText)
                }
            }
            
            Section("Output") {
                Picker("To", selection: $viewModel.outputUnit) {
                    ForEach(viewModel.groupedUnits, id: \.0) { group, units in
                        Section(group) {
                            ForEach(units) { unit in
                                Text(unit.displayName).tag(unit)
                            }
                        }
                    }
                }
                .onChange(of: viewModel.outputUnit) { 
                    HapticManager.selection()
                    viewModel.convert()
                }
                
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                } else if !viewModel.result.isEmpty {
                    HStack {
                        Text(viewModel.result)
                            .font(.title2)
                            .foregroundColor(Color.Custom.resultText)
                        
                        Text(viewModel.outputUnit.symbol)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: copyResult) {
                            Image(systemName: showCopiedFeedback ? "checkmark.circle.fill" : "doc.on.doc")
                                .foregroundColor(showCopiedFeedback ? .green : Color.Custom.resultText)
                                .animation(.easeInOut, value: showCopiedFeedback)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showHistory = true
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                }
            }
        }
        .sheet(isPresented: $showHistory) {
            HistoryView(historyManager: historyManager)
        }
        .onChange(of: viewModel.result) { newResult in
            if !newResult.isEmpty && viewModel.error == nil {
                historyManager.addConversion(
                    category: viewModel.category.name,
                    inputValue: viewModel.inputValue,
                    inputUnit: viewModel.inputUnit.symbol,
                    outputValue: newResult,
                    outputUnit: viewModel.outputUnit.symbol
                )
            }
        }
    }
    
    private func swapUnits() {
        let temp = viewModel.inputUnit
        viewModel.inputUnit = viewModel.outputUnit
        viewModel.outputUnit = temp
        viewModel.convert()
    }
    
    private func copyResult() {
        let resultText = "\(viewModel.result) \(viewModel.outputUnit.symbol)"
        UIPasteboard.general.string = resultText
        
        HapticManager.notification(type: .success)
        withAnimation {
            showCopiedFeedback = true
        }
        
        // Reset the checkmark after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopiedFeedback = false
            }
        }
    }
} 