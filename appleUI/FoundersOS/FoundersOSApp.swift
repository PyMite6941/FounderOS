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

        // Attempt 1: open the existing on-disk store. Additive changes
        // (like the new `completedMvpFeatures` field) are migrated
        // automatically by SwiftData.
        do {
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("⚠️ Failed to open on-disk store, falling back to in-memory: \(error.localizedDescription)")
        }

        // Attempt 2: fall back to an in-memory store so the app can still
        // launch. The user keeps the new feature; previously-saved ideas
        // from the old schema won't be visible until the store is rebuilt.
        do {
            let memoryConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true,
                allowsSave: true
            )
            return try ModelContainer(for: schema, configurations: [memoryConfiguration])
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
