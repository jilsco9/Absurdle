//
//  ContentView.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Stats]
    
    @EnvironmentObject var gameEngine: GameEngine
    
    @State var submittedGuesses: [[LetterResult]] = []
    @State var currentRow: Int = 0
    @State var currentGuess: String = ""
    
    func getResults(column: Int, row: Int) -> LetterResult {
        return submittedGuesses[row][column]
    }
    
    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 5, verticalSpacing: 10) {
            ForEach(0..<6) { row in
                GridRow {
                    ForEach(0..<5) { column in
                        if row < currentRow {
                            ResultSquare(result: getResults(column: column, row: row))
                        } else if row == currentRow {
                            CurrentRowView(column: column, currentGuess: $currentGuess)
                        } else {
                            Rectangle().foregroundStyle(.gray)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
        .padding()
        .onChange(of: currentGuess) {
            Task {
                if currentGuess.count == 5 {
                    do {
                        let results = try await gameEngine.guessWord(currentGuess)
                        submittedGuesses.append(results)
                        currentRow += 1
                        currentGuess = ""
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .task {
            do {
                try await gameEngine.getGameDetails()
            } catch {
                print(error)
            }
        }
        
    }
}

struct CurrentRowView: View {
    let column: Int
    @Binding var currentGuess: String
    @State var currentLetter: String = ""
    var currentColumn: Int {
        currentGuess.count
    }
    
    func getLetter(forColumn: Int) -> String? {
        let characters = Array(currentGuess)
        return String(characters[forColumn])
    }
    
    var body: some View {
        if column < currentColumn {
            Text(getLetter(forColumn: column) ?? "")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .font(.largeTitle)
                .background(
                    Rectangle().foregroundStyle(.white)
                        .border(.black)
                        .aspectRatio(1, contentMode: .fit)
                )
                .aspectRatio(1, contentMode: .fit)
        } else if column == currentColumn {
            TextEntrySquare(column: column, currentGuess: $currentGuess)
        } else {
            Rectangle().foregroundStyle(.white)
                .border(.black)
                .aspectRatio(1, contentMode: .fit)
        }
    }
    
}

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
            .focused($isFocused)
            .background(
                Rectangle().foregroundStyle(.white)
                    .border(.black)
                    .aspectRatio(1, contentMode: .fill)
            )
            .onAppear {
                isFocused = true
            }
    }
}


struct ResultSquare: View {
    let result: LetterResult
    
    var body: some View {
        switch result {
        case .correctLocation(let letter):
            Text(letter)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .font(.largeTitle)
                .background(
                    Rectangle().foregroundStyle(.green)
                        .border(.black)
                        .aspectRatio(1, contentMode: .fit)
                )
                .aspectRatio(1, contentMode: .fit)
        case .incorrectLocation(let letter):
            Text(letter)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .font(.largeTitle)
                .background(
                    Rectangle().foregroundStyle(.yellow)
                        .border(.black)
                        .aspectRatio(1, contentMode: .fit)
                )
                .aspectRatio(1, contentMode: .fit)
        case .notInWord(let letter):
            Text(letter)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .font(.largeTitle)
                .background(
                    Rectangle().foregroundStyle(.gray)
                        .border(.black)
                        .aspectRatio(1, contentMode: .fit)
                )
                .aspectRatio(1, contentMode: .fit)
        case .unknown:
            EmptyView()
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(GameEngine())
        .modelContainer(for: Stats.self, inMemory: true)
}
