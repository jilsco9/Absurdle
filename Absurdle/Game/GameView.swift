//
//  GameView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI
import SwiftData

struct GameView: View {
    
    @EnvironmentObject var gameEngine: GameEngine
    
    @State var currentRow: Int = 0
    @State var currentGuess: String = ""
    @State var submittedGuesses: [[GuessedLetterResult]] = []
    @State var shouldAnimateLastGuess: Bool = false
    
    @Binding var gameState: GameContainerView.GameState
        
    let rows = GameEngine.guessesMax
    let columns = GameEngine.wordLength
    
    func revealResults(for row: Int) {
        for column in 0..<GameEngine.wordLength {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(column) * 0.2) {
                self.submittedGuesses[row][column].revealed.toggle()
            }
        }
    }
    
    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 5, verticalSpacing: 10) {
            ForEach(0..<rows, id: \.self) { row in
                GridRow {
                    ForEach(0..<GameEngine.wordLength, id: \.self) { column in
                        GuessView(
                            row: row, 
                            column: column,
                            currentRow: currentRow,
                            submittedGuesses: $submittedGuesses,
                            currentGuess: $currentGuess,
                            gameState: gameState
                        )
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
                        revealResults(for: currentRow)
                        
                        if let gameResult = gameEngine.resultIfGameShouldEnd(latestGuess: result, guesses: submittedGuesses.count) {
                            print("Finishing game")
                            gameState = .finished(result: gameResult)
                        }
                        
                        currentRow += 1
                        currentGuess = ""
                    } catch {
                        print(error)
                    }
                }
            }
        }

        
    }
}
