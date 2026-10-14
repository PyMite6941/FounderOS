//
//  FoundersOSApp.swift
//  FoundersOS
//
//  Main app entry point with SwiftData configuration.
//

import SwiftUI
import SwiftData

@main
struct FoundersOSApp: App {
    
    // MARK: - Properties
    
    /// SwiftData model container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StartupIdea.self,
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // MARK: - App Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
