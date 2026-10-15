//
//  StartupDetailView.swift
//  FoundersOS
//
//  Detailed view of a startup idea with all 6 sections.
//

import SwiftUI
import SwiftData

struct StartupDetailView: View {
    // Two init paths: from StartupIdea (saved) or from StartupViewModel (new analysis)
    @State private var startup: StartupIdea?
    @State private var viewModel: StartupViewModel
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showStatusPicker = false
    @State private var showDeleteConfirmation = false
    @State private var showMVPDetail = false
    @State private var showValidation = false
    
    // Init from saved StartupIdea
    init(startup: StartupIdea) {
        _startup = State(initialValue: startup)
        _viewModel = State(initialValue: StartupViewModel(startupIdea: startup))
    }
    
    // Init from StartupViewModel (new analysis)
    init(viewModel: StartupViewModel) {
        _startup = State(initialValue: nil)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.founderBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: FounderSpacing.xxl) {
                    // Header
                    detailHeader
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Section 01: Problem
                    SectionCard(
                        title: "The Problem",
                        content: viewModel.problem,
                        icon: "exclamationmark.triangle",
                        stepNumber: "01"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Section 02: Customer
                    SectionCard(
                        title: "Who experiences it?",
                        content: viewModel.targetUsers.joined(separator: ", "),
                        icon: "person.2",
                        stepNumber: "02"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Target user pills
                    if !viewModel.targetUsers.isEmpty {
                        FlowLayout(spacing: FounderSpacing.xs) {
                            ForEach(viewModel.targetUsers, id: \.self) { user in
                                TagPill(text: user)
                            }
                        }
                        .padding(.horizontal, FounderSpacing.lg)
                    }
                    
                    // Section 03: Solution
                    SectionCard(
                        title: "What does the product do?",
                        content: viewModel.solution,
                        icon: "lightbulb",
                        stepNumber: "03"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Section 04: MVP
                    mvpSection
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Section 05: Business
                    SectionCard(
                        title: "How could it make money?",
                        content: viewModel.businessModel,
                        icon: "dollarsign.circle",
                        stepNumber: "05"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Section 06: Next Move
                    SectionCard(
                        title: "What should you do next?",
                        content: viewModel.nextStep,
                        icon: "arrow.right.circle",
                        stepNumber: "06"
                    )
                    .padding(.horizontal, FounderSpacing.lg)
                    
                    // Validation questions preview
                    validationPreview
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Bottom actions
                    bottomActions
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, FounderSpacing.md)
            }
        }
        .navigationTitle(viewModel.startupName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showStatusPicker = true
                    } label: {
                        Label("Change Status", systemImage: "tag")
                    }
                    
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.founderAccent)
                }
            }
        }
        .sheet(isPresented: $showStatusPicker) {
            StatusPickerSheet(
                currentStatus: viewModel.status,
                onSelect: { newStatus in
                    viewModel.updateStatus(newStatus, context: modelContext)
                    showStatusPicker = false
                }
            )
            .presentationDetents([.height(300)])
        }
        .confirmationDialog(
            "Delete this idea?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteStartup()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .navigationDestination(isPresented: $showMVPDetail) {
            MVPView(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $showValidation) {
            ValidationView(viewModel: viewModel)
        }
    }
    
    // MARK: - Detail Header
    
    private var detailHeader: some View {
        VStack(spacing: FounderSpacing.md) {
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
            
            // Status badge
            StatusBadge(status: viewModel.status)
        }
    }
    
    // MARK: - MVP Section
    
    private var mvpSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            HStack {
                Text("Build this first")
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderPrimaryText)
                
                Spacer()
                
                Text("MVP")
                    .font(FounderTypography.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.founderAccent)
                    .padding(.horizontal, FounderSpacing.sm)
                    .padding(.vertical, FounderSpacing.xxs)
                    .background(Color.founderAccent.opacity(0.15))
                    .cornerRadius(FounderCornerRadius.small)
            }
            
            VStack(spacing: FounderSpacing.sm) {
                ForEach(Array(viewModel.mvpFeatures.enumerated()), id: \.offset) { index, feature in
                    HStack(spacing: FounderSpacing.sm) {
                        Text(String(format: "%02d", index + 1))
                            .font(FounderTypography.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.founderAccent)
                            .frame(width: 28)
                        
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
            
            // Later features warning
            if !viewModel.laterFeatures.isEmpty {
                VStack(alignment: .leading, spacing: FounderSpacing.sm) {
                    Text("Don't build yet:")
                        .font(FounderTypography.subheadline)
                        .foregroundColor(.founderSecondaryText)
                    
                    FlowLayout(spacing: FounderSpacing.xs) {
                        ForEach(viewModel.laterFeatures, id: \.self) { feature in
                            TagPill(text: feature)
                        }
                    }
                }
                .padding(FounderSpacing.md)
                .background(Color.founderCard)
                .cornerRadius(FounderCornerRadius.medium)
            }
        }
    }
    
    // MARK: - Validation Preview
    
    private var validationPreview: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            HStack {
                Text("Before You Build")
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderPrimaryText)
                
                Spacer()
                
                Button {
                    showValidation = true
                } label: {
                    Text("See All")
                        .font(FounderTypography.subheadline)
                        .foregroundColor(.founderAccent)
                }
            }
            
            VStack(spacing: FounderSpacing.sm) {
                ForEach(Array(viewModel.validationQuestions.prefix(3).enumerated()), id: \.offset) { index, question in
                    ValidationQuestionCard(number: index + 1, question: question)
                }
            }
        }
        .padding(FounderSpacing.lg)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.large)
    }
    
    // MARK: - Bottom Actions
    
    private var bottomActions: some View {
        VStack(spacing: FounderSpacing.md) {
            FounderButton(
                title: "Build the MVP",
                action: { showMVPDetail = true }
            )
            
            Text(AppConstants.validationGoal)
                .font(FounderTypography.subheadline)
                .foregroundColor(.founderSecondaryText)
        }
    }
    
    // MARK: - Private Methods
    
    private func deleteStartup() {
        viewModel.deleteStartup(context: modelContext)
        dismiss()
    }
}

// MARK: - Status Picker Sheet

struct StatusPickerSheet: View {
    let currentStatus: String
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: FounderSpacing.lg) {
            Text("Change Status")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
                .padding(.top, FounderSpacing.lg)
            
            VStack(spacing: FounderSpacing.sm) {
                ForEach(StartupIdea.Status.allCases, id: \.rawValue) { status in
                    Button {
                        onSelect(status.rawValue)
                    } label: {
                        HStack {
                            Text(status.rawValue)
                                .font(FounderTypography.body)
                                .foregroundColor(.founderPrimaryText)
                            
                            Spacer()
                            
                            if currentStatus == status.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.founderAccent)
                            }
                        }
                        .padding(FounderSpacing.md)
                        .background(currentStatus == status.rawValue ? Color.founderAccent.opacity(0.1) : Color.clear)
                        .cornerRadius(FounderCornerRadius.medium)
                    }
                }
            }
            .padding(.horizontal, FounderSpacing.lg)
            
            Spacer()
        }
        .background(Color.founderBackground)
    }
}

#Preview {
    NavigationStack {
        StartupDetailView(
            startup: StartupIdea(
                title: "StudyLoop",
                rawIdea: "An app that helps students find study partners",
                problem: "Students often struggle to find compatible study partners who are at a similar level.",
                targetUsers: "Students, Exam prep students",
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
                tagline: "Find the right person to study with.",
                laterFeatures: ["AI tutor", "Video calls", "Gamification"]
            )
        )
    }
    .modelContainer(for: StartupIdea.self, inMemory: true)
}
