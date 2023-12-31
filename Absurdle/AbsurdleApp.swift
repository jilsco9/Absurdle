//
//  AbsurdleApp.swift
//  Absurdle
//
//  Created by Jillian Scott on 10/11/23.
//

import SwiftUI
import SwiftData

@main
struct AbsurdleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Stats.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject var gameEngine = GameEngine()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
        .environmentObject(gameEngine)
        .modelContainer(sharedModelContainer)
    }
}
