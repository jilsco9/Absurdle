//
//  CurrentGuessSquare.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI

struct CurrentGuessSquare: View {
    let column: Int
    @Binding var currentGuess: String
    @State var currentLetter: String = ""
    var currentColumn: Int {
        currentGuess.count
    }
    
    func getLetter(forColumn: Int) -> String? {
        let characters = Array(currentGuess)
        return String(characters[forColumn])
    }
    
    var body: some View {
        if column < currentColumn {
            LetterSquare(backgroundColor: .white, outlineColor: .black) {
                Text(getLetter(forColumn: column) ?? "")
            }
        } else if column == currentColumn {
            TextEntrySquare(column: column, currentGuess: $currentGuess)
        } else {
            LetterSquare(backgroundColor: .white, outlineColor: .gray) {
                Text("")
            }
        }
    }
}

