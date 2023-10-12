//
//  SquareView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/12/23.
//

import SwiftUI

struct SquareView: View {
    let backgroundColor: Color
    let outlineColor: Color
    
    var body: some View {
        Rectangle().foregroundStyle(backgroundColor)
            .border(outlineColor, width: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    SquareView(backgroundColor: .white, outlineColor: .black)
}
