//
//  StartupOverviewView.swift
//  FoundersOS
//
//  Initial overview after AI analysis - shows the startup at a glance.
//

import SwiftUI
import SwiftData

struct StartupOverviewView: View {
    @StateObject var viewModel: StartupViewModel
    let rawIdea: String
    var onSave: ((StartupIdea) -> Void)?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showFullDetail = false
    @State private var showMVPDetail = false
    @State private var showValidation = false
    
    var body: some View {
        ZStack {
            // Background
            Color.founderBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: FounderSpacing.xl) {
                    // Header with startup name
                    startupHeader
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Quick overview cards
                    overviewCards
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Problem section
                    SectionCard(
                        title: "The Problem",
                        content: viewModel.problem,
                        icon: "exclamationmark.triangle",
                        stepNumber: "01"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Target users
                    targetUsersSection
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Solution section
                    SectionCard(
                        title: "The Solution",
                        content: viewModel.solution,
                        icon: "lightbulb",
                        stepNumber: "02"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // MVP preview
                    mvpPreview
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Business model
                    SectionCard(
                        title: "How it makes money",
                        content: viewModel.businessModel,
                        icon: "dollarsign.circle",
                        stepNumber: "03"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Next step CTA
                    nextStepCTA
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // View full detail button
                    FounderButton(
                        title: "View Full Details",
                        action: { showFullDetail = true },
                        style: .secondary
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, FounderSpacing.md)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveAndDismiss()
                } label: {
                    Text("Save")
                        .font(FounderTypography.headline)
                        .foregroundColor(.founderAccent)
                }
            }
        }
        .navigationDestination(isPresented: $showFullDetail) {
            StartupDetailView(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $showMVPDetail) {
            MVPView(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $showValidation) {
            ValidationView(viewModel: viewModel)
        }
    }
    
    // MARK: - Startup Header
    
    private var startupHeader: some View {
        VStack(spacing: FounderSpacing.sm) {
            // Startup name
            Text(viewModel.startupName)
                .font(FounderTypography.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.founderPrimaryText)
                .multilineTextAlignment(.center)
            
            // Tagline
            if !viewModel.tagline.isEmpty {
                Text(viewModel.tagline)
                    .font(FounderTypography.title3)
                    .foregroundColor(.founderSecondaryText)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Overview Cards
    
    private var overviewCards: some View {
        HStack(spacing: FounderSpacing.sm) {
            // MVP card
            VStack(spacing: FounderSpacing.xs) {
                Image(systemName: "rocket")
                    .font(.system(size: 20))
                    .foregroundColor(.founderAccent)
                Text("\(viewModel.mvpFeatures.count)")
                    .font(FounderTypography.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.founderPrimaryText)
                Text("MVP Features")
                    .font(FounderTypography.caption)
                    .foregroundColor(.founderSecondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, FounderSpacing.md)
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.large)
            
            // Validation card
            VStack(spacing: FounderSpacing.xs) {
                Image(systemName: "person.2")
                    .font(.system(size: 20))
                    .foregroundColor(.founderAccent)
                Text("\(viewModel.validationQuestions.count)")
                    .font(FounderTypography.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.founderPrimaryText)
                Text("Questions")
                    .font(FounderTypography.caption)
                    .foregroundColor(.founderSecondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, FounderSpacing.md)
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.large)
        }
    }
    
    // MARK: - Target Users Section
    
    private var targetUsersSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.sm) {
            Text("Who is this for?")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            FlowLayout(spacing: FounderSpacing.xs) {
                ForEach(viewModel.targetUsers, id: \.self) { user in
                    TagPill(text: user)
                }
            }
        }
    }
    
    // MARK: - MVP Preview
    
    private var mvpPreview: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            HStack {
                Text("Build this first")
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderPrimaryText)
                
                Spacer()
                
                Button {
                    showMVPDetail = true
                } label: {
                    Text("See All")
                        .font(FounderTypography.subheadline)
                        .foregroundColor(.founderAccent)
                }
            }
            
            VStack(spacing: FounderSpacing.sm) {
                ForEach(Array(viewModel.mvpFeatures.prefix(3).enumerated()), id: \.offset) { index, feature in
                    HStack(spacing: FounderSpacing.sm) {
                        Text("\(index + 1)")
                            .font(FounderTypography.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.founderAccent)
                            .frame(width: 24)
                        
                        Text(feature)
                            .font(FounderTypography.body)
                            .foregroundColor(.founderPrimaryText)
                        
                        Spacer()
                    }
                    .padding(FounderSpacing.sm)
                    .background(Color.founderCard)
                    .cornerRadius(FounderCornerRadius.small)
                }
            }
        }
    }
    
    // MARK: - Next Step CTA
    
    private var nextStepCTA: some View {
        VStack(spacing: FounderSpacing.md) {
            Text("Your Next Move")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            Text(viewModel.nextStep)
                .font(FounderTypography.body)
                .foregroundColor(.founderSecondaryText)
                .multilineTextAlignment(.center)
            
            FounderButton(
                title: "Build the MVP",
                action: { showMVPDetail = true }
            )
            
            Button {
                showValidation = true
            } label: {
                Text("Learn how to validate")
                    .font(FounderTypography.subheadline)
                    .foregroundColor(.founderAccent)
            }
        }
        .padding(FounderSpacing.lg)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.extraLarge)
    }
    
    // MARK: - Private Methods
    
    private func saveAndDismiss() {
        // Save to persistence
        viewModel.setRawIdea(rawIdea)
        viewModel.saveStartup(context: modelContext)
        
        // Callback
        if let idea = viewModel.startupIdea {
            onSave?(idea)
        }
        
        // Dismiss
        dismiss()
    }
}

#Preview {
    NavigationStack {
        StartupOverviewView(
            viewModel: StartupViewModel(
                analysis: StartupAnalysis(
                    startupName: "StudyLoop",
                    tagline: "Find the right person to study with.",
                    problem: "Students often struggle to find compatible study partners who are at a similar level.",
                    targetUsers: ["Students", "Exam prep students", "University students"],
                    solution: "StudyLoop matches students based on subject, goal, availability, and study style.",
                    mvpFeatures: [
                        "Create student profile",
                        "Choose subject and goal",
                        "Match with students",
                        "Send invitations",
                        "Basic messaging"
                    ],
                    businessModel: "Freemium: Free basic matching, Pro with advanced filters.",
                    validationQuestions: [
                        "How do you find study partners?",
                        "What's frustrating?",
                        "Would you pay for this?"
                    ],
                    nextStep: "Interview 5 students about study challenges.",
                    laterFeatures: ["AI tutor", "Video calls", "Gamification"]
                )
            ),
            rawIdea: "An app that helps students find study partners"
        )
    }
    .modelContainer(for: StartupIdea.self, inMemory: true)
}
