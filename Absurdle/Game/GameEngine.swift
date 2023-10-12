//
//  GameEngine.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/11/23.
//

import Foundation

@MainActor
class GameEngine: ObservableObject {
    let gameClient: GameClient
    
    static let wordLength: Int = 5
    static let guessesMax: Int = 6
    
    @Published var guessHandler: GuessHandler?

    init(gameClient: GameClient = MockGameClient()) {
        self.gameClient = gameClient
    }
    
    func getGameDetails() async throws {
        let gameDetails = try await gameClient.getTodaysGame()
        guard gameDetails.targetWord.count == Self.wordLength else { throw ClientError.dataError }
        guessHandler = GuessHandler(gameDetails: gameDetails, wordLength: Self.wordLength)
    }
    
    func guessWord(_ guess: String) async throws -> [LetterResult] {
        guard let guessHandler else { throw GameError.notReady }
        
        // Validating guess
        guard guess.count == Self.wordLength else { throw GuessError.tooShort }
        let isAWord = try await gameClient.isGuessAWord(guess)
        guard isAWord else { throw GuessError.notAWord }
        
        return guessHandler.guessWord(guess)
    }
}
