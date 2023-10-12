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
    let wordLength: Int = 5
    
    @Published var guessHandler: GuessHandler?

    init(gameClient: GameClient = MockGameClient()) {
        self.gameClient = gameClient
    }
    
    func getGameDetails() async throws {
        let gameDetails = try await gameClient.getTodaysGame()
        guard gameDetails.targetWord.count == wordLength else { throw ClientError.DataError }
        guessHandler = GuessHandler(gameDetails: gameDetails, wordLength: wordLength)
    }
    
    func guessWord(_ guess: String) async throws -> [LetterResult] {
        guard let guessHandler else { throw GameError.notReady }
        
        // Validating guess
        guard guess.count == wordLength else { throw GuessError.tooShort }
        let isAWord = try await gameClient.isGuessAWord(guess)
        guard isAWord else { throw GuessError.notAWord }
        
        return guessHandler.guessWord(guess)
    }
}

enum GuessError: Error {
    case tooShort
    case notAWord
}

enum GameError: Error {
    case notReady
}

enum LetterResult {
    case correctLocation(String)
    case incorrectLocation(String)
    case notInWord(String)
    case unknown
}

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

struct GameDetails {
    let targetWord: String
    let gameDate: Date
}

enum ClientError: Error {
    case DataError
    case ServerError
}

protocol GameClient {
    func getTodaysGame() async throws -> GameDetails
    func isGuessAWord(_ guess: String) async throws -> Bool
}

actor MockGameClient: GameClient {
    func getTodaysGame() async throws -> GameDetails {
        let date = Date()
        let word = [
                "audio", "awful", "azure",
                "bingo", "boxer", "brack", "braid",
                "cadet", "crash",
                "daily", "datum", "delta", "depth", "diary", "disco",
                "extra",
                "faint", "false", "fancy", "fated", "feint", "felon",
                "gamut", "guild", "gumbo",
                "hardy", "husky",
                "idler", "inert", "inlet",
                "joust", "jumbo",
                "knave",
                "liner", "liver", "loath", "locus", "lyric",
                "macro", "madly", "misty", "mixer",
                "noble", "noisy", "noted",
                "ocean", "olive", "omega",
                "panic", "plush", "poker", "polar", "proxy", "pylon",
                "quack", "qualm", "quirk", "quota",
                "rabid", "reins", "relax",
                "satin", "satyr", "sloth", "squid", "sulky", "super",
                "talon", "thief", "think", "truly", "trunk",
                "unite", "upset", "urban",
                "valor", "vocal", "vogue",
                "wormy",
                "yacht",
                "zebra"
        ].randomElement()! // Safe to force unwrap, because we know the collection is not nil
        return GameDetails(targetWord: word, gameDate: date)
    }
    
    func isGuessAWord(_ guess: String) async throws -> Bool {
        // Give ourselves a way to test invalid words
        return guess != "xxxxx"
    }
}
