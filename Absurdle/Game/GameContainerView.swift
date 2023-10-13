//
//  GameContainerView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/13/23.
//

import SwiftUI
import SwiftData

struct GameContainerView: View {
    enum GameState {
        case loading
        case ongoing
        case finished(result: GameResult)
    }
    
    @EnvironmentObject var gameEngine: GameEngine
    @State var gameState: GameState = .loading
    @Query private var stats: [Stats]
    @Environment(\.modelContext) private var modelContext
    
    func createStatsIfNeeded() {
        if stats.first == nil {
            modelContext.insert(Stats(currentStreak: nil, longestStreak: nil, lastSolveDate: nil))
        }
    }
    
    var body: some View {
        switch gameState {
        case .loading:
            ProgressView()
                .task {
                    do {
                        createStatsIfNeeded()
                        try await gameEngine.getGameDetails()
                        gameState = .ongoing
                    } catch {
                        print(error)
                    }
                }
        case .ongoing, .finished:
            ZStack {
                GameView(gameState: $gameState)
                if case .finished(let result) = gameState, 
                    let stats = stats.first {
                    GameOverView(stats: stats, result: result)
                }
            }
        }
    }
}

struct GameOverView: View {
    @Environment(\.modelContext) private var modelContext
    
    let stats: Stats
    let result: GameResult
    
    var body: some View {
        Text(result.solved ? "Nice!" : "Next Time!")
            .padding()
            .foregroundColor(.indigo)
            .font(.largeTitle)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .foregroundStyle(.white)
                    .border(.indigo, width: 2)
            }
        .onAppear {
            // TODO: - Also would compare previous last solved date
            // to determine if this win is part of a streak
            if result.solved {
                stats.lastSolveDate = result.date
                stats.currentStreak = (stats.currentStreak ?? 0) + 1
                if (stats.currentStreak ?? 0) > (stats.longestStreak ?? 0) {
                    stats.longestStreak = stats.currentStreak
                }
                
            } else {
                stats.currentStreak = 0
            }
        }
    }
}

#Preview {
    GameContainerView()
            .environmentObject(GameEngine())
            .modelContainer(for: Stats.self, inMemory: true)
    
}
