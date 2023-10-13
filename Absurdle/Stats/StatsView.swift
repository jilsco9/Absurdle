//
//  StatsView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/13/23.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var stats: [Stats]
    
    var body: some View {
        VStack {
            Text("Current Streak: \(stats.first?.currentStreak ?? 0)")
            Text("Longest Streak: \(stats.first?.longestStreak ?? 0)")
            Button("Close") {
                dismiss()
            }
        }
    }
}

#Preview {
    StatsView()
}
