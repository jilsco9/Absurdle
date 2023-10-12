//
//  GuessView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI

struct GuessView: View {
    let row: Int
    let column: Int
    let currentRow: Int
    
    @Binding var submittedGuesses: [[LetterResult]]
    @Binding var currentGuess: String
    @EnvironmentObject var gameEngine: GameEngine
    
    var body: some View {
        if row < currentRow {
            ResultSquare(result: submittedGuesses[row][column])
        } else if row == currentRow {
            CurrentGuessSquare(column: column, currentGuess: $currentGuess)
        } else {
            LetterSquare(backgroundColor: Color.futureGuessGray) {
                Text("")
            }
        }
    }
}

struct GuessView_Preview: PreviewProvider {
    @State static var currentGuess: String = ""
    @State static var submittedGuesses: [[LetterResult]] = []
    
    static var previews: some View {
        GuessView(row: 0, column: 0, currentRow: 0, submittedGuesses: $submittedGuesses, currentGuess: $currentGuess)
    }
}
