//
//  SectionCard.swift
//  FoundersOS
//
//  Card component for startup sections (Problem, Solution, MVP, etc.).
//

import SwiftUI

struct SectionCard: View {
    let title: String
    let content: String
    var icon: String? = nil
    var stepNumber: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.md) {
            // Header
            HStack(spacing: FounderSpacing.sm) {
                if let step = stepNumber {
                    Text(step)
                        .font(FounderTypography.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.founderAccent)
                        .padding(.horizontal, FounderSpacing.sm)
                        .padding(.vertical, FounderSpacing.xxs)
                        .background(Color.founderAccent.opacity(0.1))
                        .cornerRadius(FounderCornerRadius.small)
                }
                
                if let iconName = icon {
                    Image(systemName: iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.founderAccent)
                }
                
                Text(title)
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderPrimaryText)
                
                Spacer()
            }
            
            // Content
            Text(content)
                .font(FounderTypography.body)
                .foregroundColor(.founderSecondaryText)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(FounderSpacing.lg)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.large)
    }
}

#Preview {
    VStack(spacing: 16) {
        SectionCard(
            title: "The Problem",
            content: "Students often struggle to find compatible study partners who are at a similar level and working toward the same goal.",
            icon: "exclamationmark.triangle",
            stepNumber: "01"
        )
        
        SectionCard(
            title: "The Solution",
            content: "StudyLoop matches students based on subject, goal, availability, and study style.",
            icon: "lightbulb",
            stepNumber: "02"
        )
    }
    .padding()
    .background(Color.founderBackground)
}
