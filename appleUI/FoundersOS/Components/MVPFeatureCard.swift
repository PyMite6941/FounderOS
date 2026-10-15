//
//  MVPFeatureCard.swift
//  FoundersOS
//
//  Card component for MVP features.
//

import SwiftUI

struct MVPFeatureCard: View {
    let number: String
    let title: String
    var isLater: Bool = false
    
    var body: some View {
        HStack(spacing: FounderSpacing.md) {
            // Number
            Text(number)
                .font(FounderTypography.title2)
                .fontWeight(.bold)
                .foregroundColor(isLater ? .founderSecondaryText : .founderAccent)
                .frame(width: 32)
            
            // Title
            Text(title)
                .font(FounderTypography.body)
                .foregroundColor(isLater ? .founderSecondaryText : .founderPrimaryText)
            
            Spacer()
            
            // Later indicator
            if isLater {
                Text("Later")
                    .font(FounderTypography.caption)
                    .foregroundColor(.founderSecondaryText)
                    .padding(.horizontal, FounderSpacing.xs)
                    .padding(.vertical, FounderSpacing.xxs)
                    .background(Color.founderDivider)
                    .cornerRadius(FounderCornerRadius.small)
            }
        }
        .padding(FounderSpacing.md)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.medium)
    }
}

#Preview {
    VStack(spacing: 12) {
        MVPFeatureCard(number: "01", title: "Create profile")
        MVPFeatureCard(number: "02", title: "Choose subject + goal")
        MVPFeatureCard(number: "03", title: "Match with another student")
        MVPFeatureCard(number: "01", title: "AI tutor", isLater: true)
        MVPFeatureCard(number: "02", title: "Video calls", isLater: true)
    }
    .padding()
    .background(Color.founderBackground)
}
