//
//  ResultSquare.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI

struct ResultSquare: View {
    let result: LetterResult
    
    var body: some View {
        LetterSquare(backgroundColor: result.backgroundColor) {
            Text(result.text)
        }
    }
}

struct AnimatingResultSquare: View {
    @StateObject var result: GuessedLetterResult
    
    var body: some View {
        AnimatingFlipView(isFlipped: $result.revealed,
                          front: {
            LetterSquare(backgroundColor: .white) {
                Text(result.result.text)
            }
        }, back: {
            ResultSquare(result: result.result)
        })
    }
}

#Preview {
    ResultSquare(result: .correctLocation("A"))
}
