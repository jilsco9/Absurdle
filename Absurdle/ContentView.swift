//
//  ContentView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        GameView()
            .navigationTitle("Absurdle")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Label("Stats", systemImage: "chart.bar")
                            .labelStyle(.iconOnly)
                    }
                }
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
