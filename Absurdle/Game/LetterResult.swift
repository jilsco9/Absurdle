//
//  LetterResult.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI

class GuessedLetterResult: ObservableObject {
    let result: LetterResult
    @Published var revealed: Bool = false
    
    init(result: LetterResult) {
        self.result = result
    }
}

enum LetterResult {
    case correctLocation(String)
    case incorrectLocation(String)
    case notInWord(String)
    case unknown
    
    var backgroundColor: Color {
        switch self {
        case .correctLocation:
            return .correctGreen
        case .incorrectLocation:
            return .misplacedYellow
        case .notInWord:
            return .incorrectGray
        case .unknown:
            return .white
        }
    }
    
    var text: String {
        switch self {
        case .correctLocation(let text),
                .incorrectLocation(let text),
                .notInWord(let text):
            return text
        case .unknown:
            return ""
        }
    }
}
