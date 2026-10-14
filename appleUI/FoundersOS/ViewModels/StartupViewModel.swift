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
