//
//  GameClient.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import Foundation

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
