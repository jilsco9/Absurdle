//
//  TextEntrySquare.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI


struct TextEntrySquare: View {
    let column: Int
    @Binding var currentGuess: String
    @State var currentLetter: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("", text: $currentLetter)
            .onChange(of: currentLetter) {
                if !currentLetter.isEmpty {
                    currentGuess.append(currentLetter)
                    currentLetter = ""
                }
            }
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.characters)
            .focused($isFocused)
            .background(
                Rectangle().foregroundStyle(.white)
                    .border(.black, width: 2)
                    .aspectRatio(1, contentMode: .fill)
            )
            .onAppear {
                isFocused = true
            }
    }
}
