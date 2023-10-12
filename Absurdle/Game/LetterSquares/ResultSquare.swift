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

#Preview {
    ResultSquare(result: .correctLocation("A"))
}
