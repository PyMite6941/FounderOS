//
//  HomeView.swift
//  FoundersOS
//
//  Home screen - Main workspace for creating startup ideas.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.founderBackground
                    .ignoresSafeArea()
                
                // Main content
                ScrollView {
                    VStack(spacing: FounderSpacing.xl) {
                        // Header
                        HeaderView(
                            title: AppConstants.appName,
                            subtitle: AppConstants.appTagline
                        )
                        .padding(.horizontal, FounderSpacing.lg)
                        
                        // Idea Input Card
                        ideaInputCard
                            .padding(.horizontal, FounderSpacing.lg)
                        
                        // Example Ideas
                        exampleIdeasSection
                            .padding(.horizontal, FounderSpacing.lg)
                        
                        // Spacer
                        Spacer(minLength: 100)
                    }
                }
                
                // Loading overlay
                if case .loading = viewModel.loadingState {
                    LoadingView(currentStep: viewModel.currentLoadingStep)
                        .transition(.opacity)
                }
            }
            .navigationDestination(isPresented: $viewModel.showAnalysis) {
                if let analysis = viewModel.currentAnalysis {
                    StartupOverviewView(
                        viewModel: StartupViewModel(analysis: analysis),
                        rawIdea: viewModel.ideaText,
                        onSave: { _ in
                            // Save to persistence
                            PersistenceService.shared.saveStartup(
                                analysis,
                                rawIdea: viewModel.ideaText,
                                context: modelContext
                            )
                        }
                    )
                }
            }
        }
        .onAppear {
            // Reset state when view appears
            viewModel.reset()
        }
    }
    
    // MARK: - Idea Input Card
    
    private var ideaInputCard: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            // Title
            Text("What's your idea?")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            // Input field
            IdeaInput(
                text: $viewModel.ideaText,
                placeholder: "Describe your startup idea...",
                onSubmit: {
                    if viewModel.canAnalyze {
                        Task {
                            await viewModel.analyzeIdea()
                        }
                    }
                }
            )
            
            // Error message
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderError)
                    .padding(.top, FounderSpacing.xs)
            }
            
            // Character count
            HStack {
                Spacer()
                Text("\(viewModel.ideaText.count)/\(AppConstants.maxIdeaLength)")
                    .font(FounderTypography.caption)
                    .foregroundColor(.founderSecondaryText)
            }
            
            // Analyze button
            HStack {
                Spacer()
                FounderButton(
                    title: "Analyze",
                    action: {
                        Task {
                            await viewModel.analyzeIdea()
                        }
                    },
                    isDisabled: !viewModel.canAnalyze
                )
                .frame(width: 140)
                .disabled(!viewModel.canAnalyze)
            }
        }
        .padding(FounderSpacing.lg)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.extraLarge)
    }
    
    // MARK: - Example Ideas Section
    
    private var exampleIdeasSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.sm) {
            Text("Try an idea")
                .font(FounderTypography.subheadline)
                .foregroundColor(.founderSecondaryText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FounderSpacing.sm) {
                    ForEach(AppConstants.exampleIdeas, id: \.self) { idea in
                        ExampleIdeaCard(title: idea) {
                            withAnimation(FounderAnimation.easeInOut) {
                                viewModel.useExampleIdea(idea)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: StartupIdea.self, inMemory: true)
}
