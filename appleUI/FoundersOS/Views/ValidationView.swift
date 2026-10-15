//
//  ValidationView.swift
//  FoundersOS
//
//  Validation view showing interview questions for user research.
//

import SwiftUI

struct ValidationView: View {
    @ObservedObject var viewModel: StartupViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color.founderBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: FounderSpacing.xxl) {
                    // Header
                    validationHeader
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Important reminder
                    reminderCard
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Questions section
                    questionsSection
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Tips section
                    tipsSection
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Validation goal
                    validationGoalCard
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, FounderSpacing.md)
            }
        }
        .navigationTitle("Validate")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Header
    
    private var validationHeader: some View {
        VStack(spacing: FounderSpacing.sm) {
            Text("Before You Build")
                .font(FounderTypography.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.founderPrimaryText)
            
            Text("Ask potential users these questions before building anything.")
                .font(FounderTypography.subheadline)
                .foregroundColor(.founderSecondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Reminder Card
    
    private var reminderCard: some View {
        HStack(spacing: FounderSpacing.md) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.founderWarning)
            
            VStack(alignment: .leading, spacing: FounderSpacing.xxs) {
                Text("Why validate?")
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderPrimaryText)
                
                Text("Most startups fail because they build things nobody wants. Talking to users early prevents this.")
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderSecondaryText)
            }
        }
        .padding(FounderSpacing.md)
        .background(Color.founderWarning.opacity(0.1))
        .cornerRadius(FounderCornerRadius.large)
    }
    
    // MARK: - Questions Section
    
    private var questionsSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            Text("Interview Questions")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            Text("Ask these questions in casual conversations with your target users. Listen more than you talk.")
                .font(FounderTypography.footnote)
                .foregroundColor(.founderSecondaryText)
            
            VStack(spacing: FounderSpacing.md) {
                ForEach(Array(viewModel.validationQuestions.enumerated()), id: \.offset) { index, question in
                    QuestionCard(number: index + 1, question: question)
                }
            }
        }
    }
    
    // MARK: - Tips Section
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            Text("Interview Tips")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            VStack(spacing: FounderSpacing.sm) {
                TipRow(
                    icon: "person.wave.2",
                    title: "Casual setting",
                    description: "Coffee shops or video calls work well"
                )
                
                TipRow(
                    icon: "ear",
                    title: "Listen more, talk less",
                    description: "Let them share their experiences"
                )
                
                TipRow(
                    icon: "questionmark.circle",
                    title: "Ask 'why' and 'how'",
                    description: "Understand their motivations"
                )
                
                TipRow(
                    icon: "note.text",
                    title: "Take notes",
                    description: "Record insights for later analysis"
                )
                
                TipRow(
                    icon: "face.smiling",
                    title: "Be genuine",
                    description: "You're learning, not selling"
                )
            }
            .padding(FounderSpacing.md)
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.large)
        }
    }
    
    // MARK: - Validation Goal Card
    
    private var validationGoalCard: some View {
        VStack(spacing: FounderSpacing.md) {
            Text(AppConstants.validationGoal)
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
                .multilineTextAlignment(.center)
            
            // Progress indicator
            HStack(spacing: FounderSpacing.sm) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(index < 0 ? Color.founderAccent : Color.founderDivider)
                        .frame(width: 12, height: 12)
                }
            }
            
            Text("Track your conversations and update your idea status when complete.")
                .font(FounderTypography.footnote)
                .foregroundColor(.founderSecondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(FounderSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.founderAccent.opacity(0.1))
        .cornerRadius(FounderCornerRadius.large)
    }
}

// MARK: - Question Card

struct QuestionCard: View {
    let number: Int
    let question: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.sm) {
            // Header
            Button {
                withAnimation(FounderAnimation.easeInOut) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: FounderSpacing.md) {
                    // Number badge
                    ZStack {
                        Circle()
                            .fill(Color.founderAccent)
                            .frame(width: 36, height: 36)
                        
                        Text("\(number)")
                            .font(FounderTypography.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Question text
                    Text(question)
                        .font(FounderTypography.body)
                        .foregroundColor(.founderPrimaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    // Expand icon
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.founderSecondaryText)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: FounderSpacing.sm) {
                    Divider()
                        .background(Color.founderDivider)
                    
                    Text("What to listen for:")
                        .font(FounderTypography.subheadline)
                        .foregroundColor(.founderSecondaryText)
                    
                    VStack(alignment: .leading, spacing: FounderSpacing.xs) {
                        ListeningPoint(text: "Specific pain points they mention")
                        ListeningPoint(text: "Current solutions they use")
                        ListeningPoint(text: "Their willingness to pay")
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(FounderSpacing.md)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.large)
    }
}

// MARK: - Tip Row

struct TipRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: FounderSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.founderAccent)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: FounderSpacing.xxs) {
                Text(title)
                    .font(FounderTypography.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.founderPrimaryText)
                
                Text(description)
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderSecondaryText)
            }
            
            Spacer()
        }
    }
}

// MARK: - Listening Point

struct ListeningPoint: View {
    let text: String
    
    var body: some View {
        HStack(spacing: FounderSpacing.xs) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(.founderSuccess)
            
            Text(text)
                .font(FounderTypography.footnote)
                .foregroundColor(.founderSecondaryText)
        }
    }
}

#Preview {
    NavigationStack {
        ValidationView(
            viewModel: StartupViewModel(
                analysis: StartupAnalysis(
                    startupName: "StudyLoop",
                    tagline: "Find the right person to study with.",
                    problem: "Students struggle to find study partners.",
                    targetUsers: ["Students", "Exam prep students"],
                    solution: "A matching platform.",
                    mvpFeatures: [
                        "Create student profile",
                        "Choose subject and goal",
                        "Match with students"
                    ],
                    businessModel: "Freemium model.",
                    validationQuestions: [
                        "How do you currently find study partners?",
                        "What is frustrating about your current solution?",
                        "Would you pay for a better solution?"
                    ],
                    nextStep: "Interview 5 students."
                )
            )
        )
    }
}
