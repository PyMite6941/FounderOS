//
//  CreateIdeaView.swift
//  FoundersOS
//
//  Create new idea view - Alternative entry point for creating ideas.
//

import SwiftUI

struct CreateIdeaView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Color.founderBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: FounderSpacing.xl) {
                    // Header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.founderSecondaryText)
                                .frame(width: 36, height: 36)
                                .background(Color.founderCard)
                                .cornerRadius(FounderCornerRadius.small)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, FounderSpacing.lg)
                    .padding(.top, FounderSpacing.md)
                    
                    // Title
                    VStack(alignment: .leading, spacing: FounderSpacing.xs) {
                        Text("What's your idea?")
                            .font(FounderTypography.largeTitle)
                            .foregroundColor(.founderPrimaryText)
                        
                        Text("Describe your startup idea in a few sentences.")
                            .font(FounderTypography.subheadline)
                            .foregroundColor(.founderSecondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Input
                    IdeaInput(
                        text: $viewModel.ideaText,
                        placeholder: "Describe your startup idea..."
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Error
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(FounderTypography.footnote)
                            .foregroundColor(.founderError)
                            .padding(.horizontal, FounderSpacing.lg)
                    }
                    
                    // Example ideas
                    VStack(alignment: .leading, spacing: FounderSpacing.sm) {
                        Text("Or try one of these")
                            .font(FounderTypography.subheadline)
                            .foregroundColor(.founderSecondaryText)
                            .padding(.horizontal, FounderSpacing.lg)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: FounderSpacing.sm) {
                                ForEach(AppConstants.exampleIdeas, id: \.self) { idea in
                                    ExampleIdeaCard(title: idea) {
                                        viewModel.useExampleIdea(idea)
                                    }
                                }
                            }
                            .padding(.horizontal, FounderSpacing.lg)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Bottom button
            VStack {
                Spacer()
                
                FounderButton(
                    title: "Analyze Idea",
                    action: {
                        Task {
                            await viewModel.analyzeIdea()
                        }
                    },
                    isDisabled: !viewModel.canAnalyze
                )
                .padding(.horizontal, FounderSpacing.lg)
                .padding(.bottom, FounderSpacing.xl)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CreateIdeaView()
}
