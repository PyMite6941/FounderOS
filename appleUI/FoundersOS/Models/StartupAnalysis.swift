//
//  StartupAnalysis.swift
//  FoundersOS
//
//  Model for AI-generated startup analysis (non-persistent).
//

import Foundation

/// Represents the AI-generated analysis of a startup idea
struct StartupAnalysis: Codable, Identifiable {
    /// Unique identifier
    var id: UUID = UUID()
    
    /// The generated startup name
    var startupName: String
    
    /// Short tagline for the startup
    var tagline: String
    
    /// The problem being solved
    var problem: String
    
    /// Target users description
    var targetUsers: [String]
    
    /// The proposed solution
    var solution: String
    
    /// MVP features (3-5 items)
    var mvpFeatures: [String]
    
    /// Proposed business model
    var businessModel: String
    
    /// Validation interview questions
    var validationQuestions: [String]
    
    /// Recommended next step
    var nextStep: String
    
    /// Features to build later (not MVP)
    var laterFeatures: [String]
    
    /// Coding: Initialize from JSON decoder
    enum CodingKeys: String, CodingKey {
        case startupName
        case tagline
        case problem
        case targetUsers
        case solution
        case mvpFeatures
        case businessModel
        case validationQuestions
        case nextStep
        case laterFeatures
    }
    
    init(
        startupName: String,
        tagline: String = "",
        problem: String,
        targetUsers: [String],
        solution: String,
        mvpFeatures: [String],
        businessModel: String,
        validationQuestions: [String],
        nextStep: String,
        laterFeatures: [String] = []
    ) {
        self.startupName = startupName
        self.tagline = tagline
        self.problem = problem
        self.targetUsers = targetUsers
        self.solution = solution
        self.mvpFeatures = mvpFeatures
        self.businessModel = businessModel
        self.validationQuestions = validationQuestions
        self.nextStep = nextStep
        self.laterFeatures = laterFeatures
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startupName = try container.decode(String.self, forKey: .startupName)
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        problem = try container.decode(String.self, forKey: .problem)
        targetUsers = try container.decode([String].self, forKey: .targetUsers)
        solution = try container.decode(String.self, forKey: .solution)
        mvpFeatures = try container.decode([String].self, forKey: .mvpFeatures)
        businessModel = try container.decode(String.self, forKey: .businessModel)
        validationQuestions = try container.decode([String].self, forKey: .validationQuestions)
        nextStep = try container.decode(String.self, forKey: .nextStep)
        laterFeatures = try container.decodeIfPresent([String].self, forKey: .laterFeatures) ?? []
    }
    
    /// Convert analysis to StartupIdea model for persistence
    func toStartupIdea() -> StartupIdea {
        return StartupIdea(
            title: startupName,
            rawIdea: "", // Will be set separately
            problem: problem,
            targetUsers: targetUsers.joined(separator: ", "),
            solution: solution,
            mvpFeatures: mvpFeatures,
            businessModel: businessModel,
            validationQuestions: validationQuestions,
            nextStep: nextStep,
            tagline: tagline,
            laterFeatures: laterFeatures
        )
    }
}

/// AI service response wrapper
struct AIResponse: Codable {
    var analysis: StartupAnalysis?
    var error: String?
    
    enum CodingKeys: String, CodingKey {
        case analysis = "analysis"
        case error = "error"
    }
}

/// Loading states for AI generation
enum LoadingState: Equatable {
    case idle
    case loading(currentStep: String)
    case success
    case error(message: String)
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading(let l), .loading(let r)):
            return l == r
        case (.success, .success):
            return true
        case (.error(let l), .error(let r)):
            return l == r
        default:
            return false
        }
    }
}

/// Loading step messages
struct LoadingSteps {
    static let messages = [
        "Understanding the problem",
        "Finding your users",
        "Designing the MVP",
        "Building your startup map"
    ]
}
