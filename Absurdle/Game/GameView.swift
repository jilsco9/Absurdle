//
//  GameView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Stats]
    
    @EnvironmentObject var gameEngine: GameEngine
    
    @State var currentRow: Int = 0
    @State var currentGuess: String = ""
    @State var submittedGuesses: [[LetterResult]] = []
        
    let rows = GameEngine.guessesMax
    let columns = GameEngine.wordLength
    
    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 5, verticalSpacing: 10) {
            ForEach(0..<rows, id: \.self) { row in
                GridRow {
                    ForEach(0..<GameEngine.wordLength, id: \.self) { column in
                        GuessView(row: row, column: column, currentRow: currentRow, submittedGuesses: $submittedGuesses, currentGuess: $currentGuess)
                    }
                }
            }
        }
        .padding()
        .onChange(of: currentGuess) {
            Task {
                if currentGuess.count == GameEngine.wordLength {
                    do {
                        let result = try await gameEngine.guessWord(currentGuess)
                        submittedGuesses.append(result)
                        currentRow += 1
                        currentGuess = ""
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .task {
            do {
                try await gameEngine.getGameDetails()
            } catch {
                print(error)
            }
        }
        
    }
}

#Preview {
    GameView()
        .environmentObject(GameEngine())
        .modelContainer(for: Stats.self, inMemory: true)
}
