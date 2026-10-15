//
//  StartupViewModel.swift
//  FoundersOS
//
//  ViewModel for startup overview, MVP, and validation screens.
//

import Foundation
import SwiftUI
import SwiftData

/// ViewModel for startup detail screens
@MainActor
class StartupViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current startup idea
    @Published var startupIdea: StartupIdea?
    
    /// Analysis from AI
    @Published var analysis: StartupAnalysis?
    
    /// Raw idea text
    @Published var rawIdea: String = ""
    
    /// Current view section
    @Published var currentSection: Int = 0
    
    /// Show status picker
    @Published var showStatusPicker: Bool = false
    
    // MARK: - Initialization
    
    init(analysis: StartupAnalysis? = nil, startupIdea: StartupIdea? = nil) {
        self.analysis = analysis
        self.startupIdea = startupIdea
        if let analysis = analysis {
            self.rawIdea = "" // Will be set from HomeViewModel
        }
    }
    
    // MARK: - Computed Properties
    
    /// Startup name
    var startupName: String {
        startupIdea?.title ?? analysis?.startupName ?? "New Startup"
    }
    
    /// Startup tagline
    var tagline: String {
        startupIdea?.tagline ?? analysis?.tagline ?? ""
    }
    
    /// Problem statement
    var problem: String {
        startupIdea?.problem ?? analysis?.problem ?? ""
    }
    
    /// Target users
    var targetUsers: [String] {
        if let users = startupIdea?.targetUsers, !users.isEmpty {
            return users.components(separatedBy: ", ")
        }
        return analysis?.targetUsers ?? []
    }
    
    /// Solution description
    var solution: String {
        startupIdea?.solution ?? analysis?.solution ?? ""
    }
    
    /// MVP features
    var mvpFeatures: [String] {
        startupIdea?.mvpFeatures ?? analysis?.mvpFeatures ?? []
    }
    
    /// Later features (NOT MVP)
    var laterFeatures: [String] {
        startupIdea?.laterFeatures ?? analysis?.laterFeatures ?? []
    }
    
    /// Business model
    var businessModel: String {
        startupIdea?.businessModel ?? analysis?.businessModel ?? ""
    }
    
    /// Validation questions
    var validationQuestions: [String] {
        startupIdea?.validationQuestions ?? analysis?.validationQuestions ?? []
    }
    
    /// Next step recommendation
    var nextStep: String {
        startupIdea?.nextStep ?? analysis?.nextStep ?? ""
    }
    
    /// Current status
    var status: String {
        startupIdea?.status ?? "Idea"
    }

    /// Names of MVP features the user has checked off as completed.
    var completedMvpFeatures: [String] {
        startupIdea?.completedMvpFeatures ?? []
    }

    /// "Build Later" is unlocked only after every Must-Have MVP feature is done.
    var isLaterUnlocked: Bool {
        let mvp = mvpFeatures
        guard !mvp.isEmpty else { return false }
        return mvp.allSatisfy { completedMvpFeatures.contains($0) }
    }

    /// Count of Must-Have features the user has finished.
    var completedMvpCount: Int {
        let mvp = mvpFeatures
        return mvp.filter { completedMvpFeatures.contains($0) }.count
    }
    
    // MARK: - Section Definitions
    
    /// All sections for the startup overview
    var sections: [(title: String, icon: String, number: String)] {
        [
            ("The Problem", "exclamationmark.triangle", "01"),
            ("Who is this for?", "person.2", "02"),
            ("The Solution", "lightbulb", "03"),
            ("Build This First", "rocket", "04"),
            ("How it makes money", "dollarsign.circle", "05"),
            ("Your Next Move", "arrow.right.circle", "06")
        ]
    }
    
    // MARK: - Public Methods
    
    /// Set the raw idea text
    func setRawIdea(_ idea: String) {
        rawIdea = idea
    }
    
    /// Save the startup to persistence
    func saveStartup(context: ModelContext) {
        if let existing = startupIdea {
            // Update existing
            PersistenceService.shared.updateStartup(existing, context: context)
        } else if let analysis = analysis {
            // Create new
            PersistenceService.shared.saveStartup(analysis, rawIdea: rawIdea, context: context)
            
            // Refresh the startup idea
            let ideas = PersistenceService.shared.fetchAllStartups(context: context)
            startupIdea = ideas.first
        }
    }
    
    /// Update the status
    func updateStatus(_ newStatus: String, context: ModelContext) {
        guard let idea = startupIdea else { return }
        PersistenceService.shared.updateStatus(idea, to: newStatus, context: context)
    }

    /// Toggle an MVP feature's check-in state and persist the change.
    ///
    /// If no `StartupIdea` is bound yet (e.g. the user just generated a new
    /// analysis and hasn't saved), this materializes one in the supplied
    /// `ModelContext` and toggles into it. Tapping therefore always has
    /// visible effect, even before the user hits Save.
    /// - Parameters:
    ///   - feature: The MVP feature name to toggle
    ///   - context: The SwiftData model context
    func toggleMvpFeature(_ feature: String, context: ModelContext) {
        let idea: StartupIdea
        if let existing = startupIdea {
            idea = existing
        } else if let analysis = analysis {
            // Build a transient StartupIdea from the analysis and insert it
            // into the same context. Save will later persist it for real.
            var new = analysis.toStartupIdea()
            new.rawIdea = rawIdea
            new.createdAt = Date()
            new.updatedAt = Date()
            context.insert(new)
            startupIdea = new
            idea = new
        } else {
            return
        }

        var current = idea.completedMvpFeatures
        if let idx = current.firstIndex(of: feature) {
            current.remove(at: idx)
        } else {
            current.append(feature)
        }
        idea.completedMvpFeatures = current
        idea.updatedAt = Date()
        do {
            try context.save()
        } catch {
            print("❌ Failed to save MVP toggle: \(error.localizedDescription)")
        }
        // Force a UI refresh for the freshly-mutated model.
        objectWillChange.send()
    }
    
    /// Delete the startup
    func deleteStartup(context: ModelContext) {
        guard let idea = startupIdea else { return }
        PersistenceService.shared.deleteStartup(idea, context: context)
    }
    
    /// Go to next section
    func nextSection() {
        if currentSection < sections.count - 1 {
            withAnimation(FounderAnimation.easeInOut) {
                currentSection += 1
            }
        }
    }
    
    /// Go to previous section
    func previousSection() {
        if currentSection > 0 {
            withAnimation(FounderAnimation.easeInOut) {
                currentSection -= 1
            }
        }
    }
    
    /// Jump to specific section
    func goToSection(_ index: Int) {
        guard index >= 0 && index < sections.count else { return }
        withAnimation(FounderAnimation.easeInOut) {
            currentSection = index
        }
    }
}
