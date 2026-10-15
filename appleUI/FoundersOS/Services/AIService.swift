//
//  AIService.swift
//  FoundersOS
//
//  AI service for generating startup analyses.
//  Connects to the shared FounderOS API at POST /v1/analyze.
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

    /// The build setting can point simulators and devices at the deployed API.
    private var endpoint: URL? {
        guard
            let baseURLString = Bundle.main.object(forInfoDictionaryKey: "FOUNDEROS_API_BASE_URL") as? String,
            let baseURL = URL(string: baseURLString),
            let scheme = baseURL.scheme?.lowercased(),
            scheme == "http" || scheme == "https"
        else {
            return nil
        }
        return baseURL.appendingPathComponent("v1").appendingPathComponent("analyze")
    }

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    /// Analyze a startup idea through the shared backend.
    /// - Parameter idea: The raw startup idea from the user
    /// - Returns: Structured startup analysis from the backend
    func analyzeIdea(_ idea: String) async throws -> StartupAnalysis {
        guard let endpoint else {
            throw AIServiceError.invalidURL
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = AnalyzeRequest(idea: idea, client: "ios")
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
            guard let analysis = try JSONDecoder().decode(AIResponse.self, from: data).analysis else {
                throw AIServiceError.decodingError
            }
            return analysis
        } catch {
            throw AIServiceError.decodingError
        }
    }
}

private struct AnalyzeRequest: Encodable {
    let idea: String
    let client: String
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