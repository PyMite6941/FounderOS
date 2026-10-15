//
//  PersistenceService.swift
//  FoundersOS
//
//  Service for managing SwiftData persistence.
//

import Foundation
import SwiftData

/// Service for managing startup ideas persistence
class PersistenceService {
    
    // MARK: - Properties
    
    /// Shared instance
    static let shared = PersistenceService()
    
    /// SwiftData model container
    private var modelContainer: ModelContainer?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Configure the model container
    /// - Parameter container: The SwiftData ModelContainer
    func configure(with container: ModelContainer) {
        self.modelContainer = container
    }
    
    /// Save a startup idea. If an idea with the same `rawIdea` text already
    /// exists, it is updated in place rather than inserted as a duplicate.
    /// - Parameters:
    ///   - analysis: The startup analysis to save
    ///   - rawIdea: The original idea text entered by the user
    ///   - context: The SwiftData model context
    func saveStartup(_ analysis: StartupAnalysis, rawIdea: String, context: ModelContext) {
        let trimmedRaw = rawIdea.trimmingCharacters(in: .whitespacesAndNewlines)

        // De-dupe: if an idea with the same raw text already exists, update it.
        if !trimmedRaw.isEmpty,
           let existing = fetchStartup(byRawIdea: trimmedRaw, context: context) {
            existing.title = analysis.startupName
            existing.problem = analysis.problem
            existing.targetUsers = analysis.targetUsers.joined(separator: ", ")
            existing.solution = analysis.solution
            existing.mvpFeatures = analysis.mvpFeatures
            existing.businessModel = analysis.businessModel
            existing.validationQuestions = analysis.validationQuestions
            existing.nextStep = analysis.nextStep
            existing.tagline = analysis.tagline
            existing.laterFeatures = analysis.laterFeatures
            existing.updatedAt = Date()

            do {
                try context.save()
                print("✅ Startup updated (deduped): \(existing.title)")
            } catch {
                print("❌ Failed to update startup: \(error.localizedDescription)")
            }
            return
        }

        var startupIdea = analysis.toStartupIdea()
        startupIdea.rawIdea = rawIdea
        startupIdea.createdAt = Date()
        startupIdea.updatedAt = Date()

        context.insert(startupIdea)

        do {
            try context.save()
            print("✅ Startup saved successfully: \(startupIdea.title)")
        } catch {
            print("❌ Failed to save startup: \(error.localizedDescription)")
        }
    }
    
    /// Update an existing startup idea
    /// - Parameters:
    ///   - idea: The startup idea to update
    ///   - context: The SwiftData model context
    func updateStartup(_ idea: StartupIdea, context: ModelContext) {
        idea.updatedAt = Date()
        
        do {
            try context.save()
            print("✅ Startup updated successfully: \(idea.title)")
        } catch {
            print("❌ Failed to update startup: \(error.localizedDescription)")
        }
    }
    
    /// Delete a startup idea
    /// - Parameters:
    ///   - idea: The startup idea to delete
    ///   - context: The SwiftData model context
    func deleteStartup(_ idea: StartupIdea, context: ModelContext) {
        context.delete(idea)
        
        do {
            try context.save()
            print("✅ Startup deleted successfully")
        } catch {
            print("❌ Failed to delete startup: \(error.localizedDescription)")
        }
    }
    
    /// Fetch all startup ideas
    /// - Parameter context: The SwiftData model context
    /// - Returns: Array of all startup ideas sorted by creation date
    func fetchAllStartups(context: ModelContext) -> [StartupIdea] {
        let descriptor = FetchDescriptor<StartupIdea>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            let ideas = try context.fetch(descriptor)
            print("📦 Fetched \(ideas.count) startups")
            return ideas
        } catch {
            print("❌ Failed to fetch startups: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Fetch a specific startup by ID
    /// - Parameters:
    ///   - id: The UUID of the startup
    ///   - context: The SwiftData model context
    /// - Returns: The startup idea if found
    func fetchStartup(by id: UUID, context: ModelContext) -> StartupIdea? {
        let predicate = #Predicate<StartupIdea> { idea in
            idea.id == id
        }

        var descriptor = FetchDescriptor<StartupIdea>(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            let ideas = try context.fetch(descriptor)
            return ideas.first
        } catch {
            print("❌ Failed to fetch startup: \(error.localizedDescription)")
            return nil
        }
    }

    /// Fetch a startup by its raw idea text (used to dedupe saves).
    /// - Parameters:
    ///   - rawIdea: The original idea text entered by the user
    ///   - context: The SwiftData model context
    /// - Returns: The existing startup idea if one matches
    func fetchStartup(byRawIdea rawIdea: String, context: ModelContext) -> StartupIdea? {
        let predicate = #Predicate<StartupIdea> { idea in
            idea.rawIdea == rawIdea
        }

        var descriptor = FetchDescriptor<StartupIdea>(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            let ideas = try context.fetch(descriptor)
            return ideas.first
        } catch {
            print("❌ Failed to fetch startup by raw idea: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Update startup status
    /// - Parameters:
    ///   - idea: The startup idea to update
    ///   - status: The new status
    ///   - context: The SwiftData model context
    func updateStatus(_ idea: StartupIdea, to status: String, context: ModelContext) {
        idea.status = status
        idea.updatedAt = Date()
        
        do {
            try context.save()
            print("✅ Status updated to \(status)")
        } catch {
            print("❌ Failed to update status: \(error.localizedDescription)")
        }
    }
}
