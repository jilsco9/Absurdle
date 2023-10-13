//
//  ContentView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingStatsSheet = false
    
    var body: some View {
        GameContainerView()
        .navigationTitle("Absurdle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingStatsSheet.toggle()
                } label: {
                    Label("Stats", systemImage: "chart.bar")
                        .labelStyle(.iconOnly)
                }
            }
        }
        .sheet(isPresented: $showingStatsSheet) {
            StatsView()
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environmentObject(GameEngine())
            .modelContainer(for: Stats.self, inMemory: true)
    }
}
