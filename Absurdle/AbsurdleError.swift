//
//  AbsurdleError.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import Foundation

enum GuessError: Error {
    case tooShort
    case notAWord
}

enum GameError: Error {
    case notReady
}

enum ClientError: Error {
    case dataError
    case serverError
}
