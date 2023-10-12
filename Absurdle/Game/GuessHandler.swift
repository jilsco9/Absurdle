//
//  GuessHandler.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import Foundation

struct GuessHandler {
    let targetWord: [Character]
    let gameDate: Date
    let wordLength: Int
    
    init(gameDetails: GameDetails, wordLength: Int) {
        self.targetWord = Array(gameDetails.targetWord.uppercased())
        self.gameDate = gameDetails.gameDate
        self.wordLength = wordLength
    }
    
    func guessWord(_ validGuess: String) -> [LetterResult] {
        let guess = Array(validGuess)
        
        var unmatchedLetters: [Character] = []
        
        var results: [LetterResult] = (0 ..< wordLength).map { index in
            if guess[index] == targetWord[index] {
                return .correctLocation(String(guess[index]))
            } else {
                unmatchedLetters.append(targetWord[index])
                return .unknown
            }
        }
        
        for index in 0 ..< wordLength {
            if case .unknown = results[index] {
                if let misplacedMatch = unmatchedLetters.firstIndex(of: guess[index]) {
                    results[index] = .incorrectLocation(String(guess[index]))
                    unmatchedLetters.remove(at: misplacedMatch)
                } else {
                    results[index] = .notInWord(String(guess[index]))
                }
            }
        }
        
        return results
    }
}
