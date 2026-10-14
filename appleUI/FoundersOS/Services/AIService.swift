//
//  AIService.swift
//  FoundersOS
//
//  AI service for generating startup analyses.
//  Uses structured JSON response format for clean data handling.
//

import Foundation

/// Protocol for AI service to enable easy provider switching
protocol AIServiceProtocol {
    func analyzeIdea(_ idea: String) async throws -> StartupAnalysis
}

/// AI Service for generating startup analyses
class AIService: AIServiceProtocol {
    
    // MARK: - Properties
    
    /// Singleton instance
    static let shared = AIService()
    
    /// Base URL for API endpoint (replace with your backend)
    private let baseURL = "https://api.yourbackend.com/v1"
    
    /// API key for authentication (should be on backend, not here)
    private let apiKey = "YOUR_API_KEY"
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Analyze a startup idea and return structured analysis
    /// - Parameter idea: The raw startup idea from user
    /// - Returns: Structured startup analysis
    func analyzeIdea(_ idea: String) async throws -> StartupAnalysis {
        // For V1, use mock data since we don't have a real backend
        // Replace this with actual API call in production
        
        // Simulate network delay for realistic UX
        try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 seconds
        
        // Return mock analysis based on idea
        return generateMockAnalysis(for: idea)
    }
    
    // MARK: - Private Methods
    
    /// Generate mock analysis for development/testing
    private func generateMockAnalysis(for idea: String) -> StartupAnalysis {
        // Parse the idea to generate relevant mock data
        let lowercaseIdea = idea.lowercased()
        
        // Default mock data
        var startupName = "StartupIdea"
        var tagline = "A solution for modern problems."
        var problem = "There's a significant problem that affects many people daily."
        var targetUsers = ["Users", "Customers"]
        var solution = "A simple, elegant solution that addresses the core issue."
        var mvpFeatures = [
            "User registration and profile creation",
            "Core feature implementation",
            "Basic search and discovery",
            "Simple messaging or interaction",
            "User settings and preferences"
        ]
        var businessModel = "Freemium model with basic free features and premium paid features."
        var validationQuestions = [
            "What is your biggest challenge with this?",
            "How do you currently solve this problem?",
            "Would you pay for a better solution?"
        ]
        var nextStep = "Interview 5 potential users to validate the problem."
        var laterFeatures = [
            "Advanced analytics",
            "AI-powered recommendations",
            "Social features",
            "Premium integrations",
            "Custom branding"
        ]
        
        // Customize based on idea content
        if lowercaseIdea.contains("study") || lowercaseIdea.contains("student") {
            startupName = "StudyLoop"
            tagline = "Find the right person to study with."
            problem = "Students often struggle to find compatible study partners who are at a similar level and working toward the same goal."
            targetUsers = ["Students", "Exam prep students", "University students"]
            solution = "StudyLoop matches students based on subject, goal, availability, and study style."
            mvpFeatures = [
                "Create student profile",
                "Choose subject and study goal",
                "Set availability schedule",
                "Match with compatible students",
                "Send and receive study invitations"
            ]
            businessModel = "Freemium model: Free basic matching, Pro version with advanced filters and priority matching."
            validationQuestions = [
                "How do you currently find study partners?",
                "What is frustrating about your current solution?",
                "Would you pay for a better study matching experience?"
            ]
            nextStep = "Interview 5 students about their study partner challenges."
            laterFeatures = [
                "AI-powered study tutor",
                "Video call integration",
                "Study session analytics",
                "Gamification system",
                "Social study feed"
            ]
        } else if lowercaseIdea.contains("food") || lowercaseIdea.contains("waste") {
            startupName = "FoodRescue"
            tagline = "Save food, feed people."
            problem = "Restaurants and grocery stores throw away good food daily while food banks struggle to meet demand."
            targetUsers = ["Restaurants", "Grocery stores", "Food banks", "Nonprofits"]
            solution = "FoodRescue connects food donors with nearby nonprofits for efficient food redistribution."
            mvpFeatures = [
                "Restaurant/donor registration",
                "Food listing creation",
                "Nonprofit dashboard",
                "Pickup scheduling",
                "Donation history tracking"
            ]
            businessModel = "Subscription model: Free for small donors, paid plans for larger operations with analytics."
            validationQuestions = [
                "How do you currently handle food waste?",
                "What barriers exist to donating food?",
                "Would you pay for a streamlined donation process?"
            ]
            nextStep = "Talk to 5 local restaurants about their food waste challenges."
            laterFeatures = [
                "Real-time inventory tracking",
                "Route optimization for pickups",
                "Tax document automation",
                "Corporate partnership features",
                "Mobile donation app"
            ]
        } else if lowercaseIdea.contains("transport") || lowercaseIdea.contains("local") {
            startupName = "TransitLocal"
            tagline = "Getting around, locally."
            problem = "People in rural and suburban areas lack affordable, convenient transportation options."
            targetUsers = ["Rural residents", "Elderly", "Students without cars"]
            solution = "TransitLocal connects residents with local drivers and shared transportation options."
            mvpFeatures = [
                "User registration with location",
                "Ride request creation",
                "Driver matching",
                "In-app messaging",
                "Simple payment processing"
            ]
            businessModel = "Commission-based: Small fee per ride, premium subscription for unlimited rides."
            validationQuestions = [
                "How do you currently get around locally?",
                "What are the biggest transportation challenges?",
                "Would you use a local ridesharing service?"
            ]
            nextStep = "Interview 10 community members about transportation needs."
            laterFeatures = [
                "Scheduled recurring rides",
                "Bus route integration",
                "Elderly assistance features",
                "Corporate transportation",
                "Real-time tracking"
            ]
        } else if lowercaseIdea.contains("finance") || lowercaseIdea.contains("money") || lowercaseIdea.contains("budget") {
            startupName = "PennyWise"
            tagline = "Master your money, starting today."
            problem = "Young adults and students struggle to manage finances and build healthy money habits."
            targetUsers = ["Students", "Young professionals", "Budget-conscious individuals"]
            solution = "PennyWise provides simple budgeting tools and financial education for beginners."
            mvpFeatures = [
                "Expense tracking",
                "Budget category creation",
                "Spending insights",
                "Goal setting",
                "Monthly reports"
            ]
            businessModel = "Freemium: Basic tracking free, premium with investments and credit tracking."
            validationQuestions = [
                "How do you currently track your spending?",
                "What financial challenges do you face?",
                "Would you pay for better financial tools?"
            ]
            nextStep = "Survey 10 friends about their financial tracking habits."
            laterFeatures = [
                "Investment tracking",
                "Credit score monitoring",
                "AI financial advisor",
                "Bill negotiation",
                "Savings automation"
            ]
        }
        
        return StartupAnalysis(
            startupName: startupName,
            tagline: tagline,
            problem: problem,
            targetUsers: targetUsers,
            solution: solution,
            mvpFeatures: mvpFeatures,
            businessModel: businessModel,
            validationQuestions: validationQuestions,
            nextStep: nextStep,
            laterFeatures: laterFeatures
        )
    }
    
    // MARK: - Production API Call (for future implementation)
    
    /// Make actual API call to backend (placeholder for production)
    private func makeAPICall(_ idea: String) async throws -> StartupAnalysis {
        let endpoint = "\(baseURL)/analyze"
        
        guard let url = URL(string: endpoint) else {
            throw AIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let payload = ["idea": idea]
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIServiceError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw AIServiceError.serverError(statusCode: httpResponse.statusCode)
        }
        
        let analysis = try JSONDecoder().decode(StartupAnalysis.self, from: data)
        return analysis
    }
}

// MARK: - Error Types

enum AIServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
