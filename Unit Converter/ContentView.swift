//
//  ContentView.swift
//  Unit Converter
//
//  Created by Jad Raad on 3/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ConversionCategoriesViewModel()
    @StateObject private var historyManager = HistoryManager()
    
    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.categories) { category in
                        CategoryCard(category: category, historyManager: historyManager)
                    }
                }
                .padding()
            }
            .navigationTitle("Unit Converter")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct CategoryCard: View {
    let category: ConversionCategory
    let historyManager: HistoryManager
    
    var body: some View {
        NavigationLink(destination: ConversionView(category: category, historyManager: historyManager)) {
            VStack {
                Image(systemName: category.icon)
                    .imageScale(.large)
                    .font(.system(size: 32))
                    .foregroundColor(Color.Custom.resultText)
                    .frame(width: 60, height: 60)
                    .background(Color.Custom.iconBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(category.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.Custom.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    ContentView()
}
