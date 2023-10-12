//
//  Item.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/11/23.
//

import Foundation
import SwiftData

@Model
final class Stats {
    var currentStreak: Int?
    var longestStreak: Int?
    var lastSolveDate: Date?
    
    init(currentStreak: Int? = nil, longestStreak: Int? = nil, lastSolveDate: Date? = nil) {
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastSolveDate = lastSolveDate
    }
}

@Model
final class GameResult {
    var date: Date?
    var guesses: Int?
    var solved: Bool?
    
    init(date: Date? = nil, guesses: Int? = nil, solved: Bool? = nil) {
        self.date = date
        self.guesses = guesses
        self.solved = solved
    }
}

