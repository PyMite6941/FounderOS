//
//  MVPView.swift
//  FoundersOS
//
//  Detailed MVP view showing Must Have vs Later features.
//

import SwiftUI

struct MVPView: View {
    @ObservedObject var viewModel: StartupViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            // Background
            Color.founderBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: FounderSpacing.xxl) {
                    // Header
                    mvpHeader
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Philosophy reminder
                    philosophyCard
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Must Have Section
                    mustHaveSection
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Later Section
                    laterSection
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    // Summary
                    summaryCard
                        .padding(.horizontal, FounderSpacing.lg)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, FounderSpacing.md)
            }
        }
        .navigationTitle("Your MVP")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Header
    
    private var mvpHeader: some View {
        VStack(spacing: FounderSpacing.sm) {
            Text("Your MVP")
                .font(FounderTypography.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.founderPrimaryText)
            
            Text("Don't build everything. Build the smallest useful version.")
                .font(FounderTypography.subheadline)
                .foregroundColor(.founderSecondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Philosophy Card
    
    private var philosophyCard: some View {
        HStack(spacing: FounderSpacing.md) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 24))
                .foregroundColor(.founderAccent)
            
            VStack(alignment: .leading, spacing: FounderSpacing.xxs) {
                Text("The MVP Philosophy")
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderPrimaryText)
                
                Text("Build only what you need to test your core assumption. Everything else is a distraction.")
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderSecondaryText)
            }
        }
        .padding(FounderSpacing.md)
        .background(Color.founderAccent.opacity(0.1))
        .cornerRadius(FounderCornerRadius.large)
    }
    
    // MARK: - Must Have Section

    private var mustHaveSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            // Section header
            HStack {
                Text("Must Have")
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderPrimaryText)

                Spacer()

                HStack(spacing: FounderSpacing.xxs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.founderSuccess)
                    Text("\(viewModel.completedMvpCount) / \(viewModel.mvpFeatures.count) done")
                        .font(FounderTypography.caption)
                        .foregroundColor(.founderSecondaryText)
                }
            }

            // Features list
            VStack(spacing: FounderSpacing.sm) {
                ForEach(Array(viewModel.mvpFeatures.enumerated()), id: \.offset) { index, feature in
                    HStack(spacing: FounderSpacing.md) {
                        // Number badge
                        ZStack {
                            Circle()
                                .fill(Color.founderAccent)
                                .frame(width: 32, height: 32)

                            Text("\(index + 1)")
                                .font(FounderTypography.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        // Feature text
                        Text(feature)
                            .font(FounderTypography.body)
                            .foregroundColor(.founderPrimaryText)
                            .strikethrough(viewModel.completedMvpFeatures.contains(feature), color: .founderSecondaryText)

                        Spacer()

                        // Check-in checkbox
                        Button {
                            viewModel.toggleMvpFeature(feature, context: modelContext)
                        } label: {
                            Image(systemName: viewModel.completedMvpFeatures.contains(feature) ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 22))
                                .foregroundColor(viewModel.completedMvpFeatures.contains(feature) ? .founderSuccess : .founderSecondaryText)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(FounderSpacing.md)
                    .background(Color.founderCard)
                    .cornerRadius(FounderCornerRadius.medium)
                }
            }

            // Tip
            HStack(spacing: FounderSpacing.sm) {
                Image(systemName: "info.circle")
                    .foregroundColor(.founderAccent)

                Text(viewModel.isLaterUnlocked
                     ? "MVP complete — Build Later is unlocked."
                     : "Start with these. Tap the circle to check one off.")
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderSecondaryText)
            }
        }
    }
    
    // MARK: - Later Section

    private var laterSection: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            // Section header
            HStack {
                HStack(spacing: FounderSpacing.xs) {
                    Text("Build Later")
                        .font(FounderTypography.headline)
                        .foregroundColor(.founderPrimaryText)

                    if !viewModel.isLaterUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.founderSecondaryText)
                    }
                }

                Spacer()

                HStack(spacing: FounderSpacing.xxs) {
                    Image(systemName: "clock")
                        .foregroundColor(.statusValidating)
                    Text("\(viewModel.laterFeatures.count) features")
                        .font(FounderTypography.caption)
                        .foregroundColor(.founderSecondaryText)
                }
            }

            // Warning
            HStack(spacing: FounderSpacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.founderWarning)

                Text(viewModel.isLaterUnlocked
                     ? "These seem cool, but they're not critical for your MVP. Resist the urge to add them early."
                     : "Finish every Must-Have feature to unlock the later ideas.")
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderSecondaryText)
            }
            .padding(FounderSpacing.sm)
            .background(Color.founderWarning.opacity(0.1))
            .cornerRadius(FounderCornerRadius.medium)

            // Features list
            if viewModel.laterFeatures.isEmpty {
                Text("Great job staying focused! No features marked for later.")
                    .font(FounderTypography.body)
                    .foregroundColor(.founderSecondaryText)
                    .padding(FounderSpacing.lg)
                    .frame(maxWidth: .infinity)
                    .background(Color.founderCard)
                    .cornerRadius(FounderCornerRadius.large)
            } else {
                VStack(alignment: .leading, spacing: FounderSpacing.sm) {
                    // Lock status — sits ABOVE the list, never overlapping it.
                    if !viewModel.isLaterUnlocked {
                        lockedLaterBanner
                    }
                    laterFeaturesList
                        .opacity(viewModel.isLaterUnlocked ? 1.0 : 0.5)
                        .allowsHitTesting(viewModel.isLaterUnlocked)
                }
            }
        }
    }

    private var laterFeaturesList: some View {
        VStack(spacing: FounderSpacing.sm) {
            ForEach(Array(viewModel.laterFeatures.enumerated()), id: \.offset) { index, feature in
                HStack(spacing: FounderSpacing.md) {
                    // Placeholder badge
                    ZStack {
                        Circle()
                            .fill(Color.founderSecondaryText.opacity(0.3))
                            .frame(width: 32, height: 32)

                        Text("\(index + 1)")
                            .font(FounderTypography.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.founderSecondaryText)
                    }

                    // Feature text
                    Text(feature)
                        .font(FounderTypography.body)
                        .foregroundColor(.founderSecondaryText)

                    Spacer()

                    // Later badge
                    Text("Later")
                        .font(FounderTypography.caption)
                        .foregroundColor(.founderSecondaryText)
                        .padding(.horizontal, FounderSpacing.xs)
                        .padding(.vertical, FounderSpacing.xxs)
                        .background(Color.founderDivider)
                        .cornerRadius(FounderCornerRadius.small)
                }
                .padding(FounderSpacing.md)
                .background(Color.founderCard)
                .cornerRadius(FounderCornerRadius.medium)
            }
        }
    }

    private var lockedLaterBanner: some View {
        HStack(spacing: FounderSpacing.xs) {
            Image(systemName: "lock.fill")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.founderSecondaryText)
            Text("Finish your MVP to see these")
                .font(FounderTypography.footnote)
                .foregroundColor(.founderSecondaryText)
            Spacer()
        }
        .padding(.horizontal, FounderSpacing.xs)
    }
    
    // MARK: - Summary Card
    
    private var summaryCard: some View {
        VStack(spacing: FounderSpacing.md) {
            Text("Focus Summary")
                .font(FounderTypography.headline)
                .foregroundColor(.founderPrimaryText)
            
            HStack(spacing: FounderSpacing.lg) {
                VStack {
                    Text("\(viewModel.mvpFeatures.count)")
                        .font(FounderTypography.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.founderSuccess)
                    Text("Build Now")
                        .font(FounderTypography.caption)
                        .foregroundColor(.founderSecondaryText)
                }
                
                Divider()
                    .frame(height: 50)
                
                VStack {
                    Text("\(viewModel.laterFeatures.count)")
                        .font(FounderTypography.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.founderSecondaryText)
                    Text("Build Later")
                        .font(FounderTypography.caption)
                        .foregroundColor(.founderSecondaryText)
                }
            }
        }
        .padding(FounderSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.large)
    }
}

#Preview {
    NavigationStack {
        MVPView(
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
                        "Match with students",
                        "Send invitations",
                        "Basic messaging"
                    ],
                    businessModel: "Freemium model.",
                    validationQuestions: [
                        "How do you find study partners?",
                        "What's frustrating?",
                        "Would you pay?"
                    ],
                    nextStep: "Interview 5 students.",
                    laterFeatures: ["AI tutor", "Video calls", "Gamification"]
                )
            )
        )
    }
}
