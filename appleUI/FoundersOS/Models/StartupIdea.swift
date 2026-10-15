//
//  StartupIdea.swift
//  FoundersOS
//
//  SwiftData model for persisting startup ideas locally.
//

import Foundation
import SwiftData

@Model
final class StartupIdea {
    /// Unique identifier for the startup idea
    var id: UUID
    
    /// The generated startup name
    var title: String
    
    /// The original idea entered by the user
    var rawIdea: String
    
    /// The problem the startup solves
    var problem: String
    
    /// Description of target users
    var targetUsers: String
    
    /// The proposed solution
    var solution: String
    
    /// List of MVP features (minimum 3-5)
    var mvpFeatures: [String]
    
    /// Proposed business model
    var businessModel: String
    
    /// Questions for user validation interviews
    var validationQuestions: [String]
    
    /// Recommended next step for the founder
    var nextStep: String
    
    /// Current status: Idea, Validating, Building
    var status: String
    
    /// When the idea was created
    var createdAt: Date
    
    /// When the idea was last updated
    var updatedAt: Date
    
    /// Tagline for the startup
    var tagline: String
    
    /// Later features that should NOT be built yet
    var laterFeatures: [String]
    
    /// Initialize a new startup idea
    init(
        id: UUID = UUID(),
        title: String = "",
        rawIdea: String = "",
        problem: String = "",
        targetUsers: String = "",
        solution: String = "",
        mvpFeatures: [String] = [],
        businessModel: String = "",
        validationQuestions: [String] = [],
        nextStep: String = "",
        status: String = "Idea",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tagline: String = "",
        laterFeatures: [String] = []
    ) {
        self.id = id
        self.title = title
        self.rawIdea = rawIdea
        self.problem = problem
        self.targetUsers = targetUsers
        self.solution = solution
        self.mvpFeatures = mvpFeatures
        self.businessModel = businessModel
        self.validationQuestions = validationQuestions
        self.nextStep = nextStep
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tagline = tagline
        self.laterFeatures = laterFeatures
    }
    
    /// Status options for tracking startup progress
    enum Status: String, CaseIterable {
        case idea = "Idea"
        case validating = "Validating"
        case building = "Building"
        
        var displayName: String {
            return rawValue
        }
    }
}
