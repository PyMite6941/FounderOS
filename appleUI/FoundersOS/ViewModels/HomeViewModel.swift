//
//  HomeViewModel.swift
//  FoundersOS
//
//  ViewModel for the Home screen.
//

import Foundation
import SwiftUI
import SwiftData

/// ViewModel for Home screen
@MainActor
class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current idea text
    @Published var ideaText: String = ""
    
    /// Loading state
    @Published var loadingState: LoadingState = .idle
    
    /// Generated analysis
    @Published var currentAnalysis: StartupAnalysis?
    
    /// Error message
    @Published var errorMessage: String?
    
    /// Current loading step index
    @Published var loadingStepIndex: Int = 0
    
    /// Whether to show the analysis view
    @Published var showAnalysis: Bool = false
    
    /// Whether to show the create idea view
    @Published var showCreateIdea: Bool = false
    
    // MARK: - Private Properties
    
    /// AI service instance
    private let aiService = AIService.shared
    
    /// Loading timer for step animation
    private var loadingTimer: Timer?
    
    // MARK: - Computed Properties
    
    /// Whether the analyze button should be enabled
    var canAnalyze: Bool {
        ideaText.trimmingCharacters(in: .whitespacesAndNewlines).count >= AppConstants.minIdeaLength
    }
    
    /// Current loading step message
    var currentLoadingStep: String {
        guard loadingStepIndex < LoadingSteps.messages.count else {
            return LoadingSteps.messages.last ?? "Building your startup map"
        }
        return LoadingSteps.messages[loadingStepIndex]
    }
    
    // MARK: - Public Methods
    
    /// Analyze the current idea
    func analyzeIdea() async {
        let trimmedIdea = ideaText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedIdea.isEmpty else {
            errorMessage = "Tell us what you're thinking about."
            return
        }
        
        guard trimmedIdea.count >= AppConstants.minIdeaLength else {
            errorMessage = "Please describe your idea in more detail."
            return
        }
        
        // Start loading
        loadingState = .loading(currentStep: currentLoadingStep)
        loadingStepIndex = 0
        startLoadingTimer()
        
        do {
            // Call AI service
            let analysis = try await aiService.analyzeIdea(trimmedIdea)
            
            // Stop loading timer
            stopLoadingTimer()
            
            // Success
            currentAnalysis = analysis
            loadingState = .success
            errorMessage = nil
            
            // Show analysis after brief delay for smooth transition
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
            showAnalysis = true
            
        } catch {
            // Stop loading timer
            stopLoadingTimer()
            
            // Error
            loadingState = .error(message: "Your idea is still here. Try again.")
            errorMessage = "Something went wrong. Please try again."
        }
    }
    
    /// Reset the view model state
    func reset() {
        ideaText = ""
        loadingState = .idle
        currentAnalysis = nil
        errorMessage = nil
        loadingStepIndex = 0
        showAnalysis = false
        stopLoadingTimer()
    }
    
    /// Use an example idea
    func useExampleIdea(_ idea: String) {
        // Map simple ideas to full descriptions
        let fullIdea: String
        switch idea {
        case "Study buddy":
            fullIdea = "An app that helps students find people to study with"
        case "Food waste":
            fullIdea = "An app that helps reduce food waste from restaurants"
        case "Local transportation":
            fullIdea = "An app that helps people find local transportation options"
        case "Student finance":
            fullIdea = "An app that helps students manage their finances and budget"
        default:
            fullIdea = idea
        }
        
        ideaText = fullIdea
        errorMessage = nil
    }
    
    /// Retry analysis after error
    func retryAnalysis() async {
        errorMessage = nil
        await analyzeIdea()
    }
    
    // MARK: - Private Methods
    
    /// Start the loading step timer
    private func startLoadingTimer() {
        stopLoadingTimer()
        loadingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.advanceLoadingStep()
            }
        }
    }
    
    /// Stop the loading timer
    private func stopLoadingTimer() {
        loadingTimer?.invalidate()
        loadingTimer = nil
    }
    
    /// Advance to the next loading step
    private func advanceLoadingStep() {
        if loadingStepIndex < LoadingSteps.messages.count - 1 {
            loadingStepIndex += 1
            loadingState = .loading(currentStep: currentLoadingStep)
        }
    }
}
