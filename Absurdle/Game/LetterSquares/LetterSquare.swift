//
//  LetterSquare.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI

struct LetterSquare<Content: View>: View {
    let backgroundColor: Color
    var outlineColor: Color = .clear
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .font(.largeTitle)
            .background(
                SquareView(backgroundColor: backgroundColor, outlineColor: outlineColor)
            )
            .aspectRatio(1, contentMode: .fit)
    }
}
