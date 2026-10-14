//
//  StartupCard.swift
//  FoundersOS
//
//  Card component for displaying saved startup ideas.
//

import SwiftUI

struct StartupCard: View {
    let startup: StartupIdea
    var onTap: (() -> Void)?
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: FounderSpacing.sm) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: FounderSpacing.xxs) {
                        Text(startup.title)
                            .font(FounderTypography.headline)
                            .foregroundColor(.founderPrimaryText)
                            .lineLimit(1)
                        
                        if !startup.tagline.isEmpty {
                            Text(startup.tagline)
                                .font(FounderTypography.subheadline)
                                .foregroundColor(.founderSecondaryText)
                                .lineLimit(2)
                        } else {
                            Text(startup.rawIdea)
                                .font(FounderTypography.subheadline)
                                .foregroundColor(.founderSecondaryText)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    // Status Badge
                    StatusBadge(status: startup.status)
                }
                
                // Problem Preview
                Text(startup.problem)
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderSecondaryText)
                    .lineLimit(3)
            }
            .padding(FounderSpacing.md)
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.large)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusBadge: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(FounderTypography.caption)
            .fontWeight(.medium)
            .foregroundColor(statusColor)
            .padding(.horizontal, FounderSpacing.sm)
            .padding(.vertical, FounderSpacing.xxs)
            .background(statusColor.opacity(0.15))
            .cornerRadius(FounderCornerRadius.small)
    }
    
    private var statusColor: Color {
        switch status {
        case "Validating":
            return .statusValidating
        case "Building":
            return .statusBuilding
        default:
            return .statusIdea
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StartupCard(startup: StartupIdea(
            title: "StudyLoop",
            rawIdea: "An app that helps students find study partners",
            problem: "Students often struggle to find compatible study partners who are at a similar level.",
            status: "Idea"
        ))
        
        StartupCard(startup: StartupIdea(
            title: "FoodRescue",
            rawIdea: "Reduce restaurant food waste",
            problem: "Restaurants throw away good food that could feed people in need.",
            status: "Validating"
        ))
        
        StartupCard(startup: StartupIdea(
            title: "TransitLocal",
            rawIdea: "Local transportation app",
            problem: "People in rural areas lack affordable transportation options.",
            status: "Building"
        ))
    }
    .padding()
    .background(Color.founderBackground)
}
