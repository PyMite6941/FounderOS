//
//  AIService.swift
//  FoundersOS
//
//  AI service for generating startup analyses.
//  Connects to the local Node.js backend at POST /v1/analyze.
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

    /// Base URL for the local backend
    private let endpoint = URL(string: "http://127.0.0.1:8787/v1/analyze")!

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    /// Analyze a startup idea by sending it to the local backend.
    /// - Parameter idea: The raw startup idea from the user
    /// - Returns: Structured startup analysis from the backend
    func analyzeIdea(_ idea: String) async throws -> StartupAnalysis {
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = ["idea": idea]
        urlRequest.httpBody = try JSONEncoder().encode(payload)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw AIServiceError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIServiceError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw AIServiceError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(StartupAnalysis.self, from: data)
        } catch {
            throw AIServiceError.decodingError
        }
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