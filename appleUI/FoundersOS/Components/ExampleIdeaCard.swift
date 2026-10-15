//
//  ExampleIdeaCard.swift
//  FoundersOS
//
//  Small horizontal card for example startup ideas.
//

import SwiftUI

struct ExampleIdeaCard: View {
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: FounderSpacing.xs) {
                Image(systemName: iconForIdea)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.founderAccent)
                
                Text(title)
                    .font(FounderTypography.footnote)
                    .foregroundColor(.founderPrimaryText)
            }
            .padding(.horizontal, FounderSpacing.sm)
            .padding(.vertical, FounderSpacing.xs)
            .background(Color.founderCard)
            .cornerRadius(FounderCornerRadius.small)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var iconForIdea: String {
        switch title.lowercased() {
        case "study buddy":
            return "person.2"
        case "food waste":
            return "leaf"
        case "local transportation":
            return "car"
        case "student finance":
            return "dollarsign.circle"
        default:
            return "lightbulb"
        }
    }
}

#Preview {
    HStack {
        ExampleIdeaCard(title: "Study buddy", onTap: {})
        ExampleIdeaCard(title: "Food waste", onTap: {})
        ExampleIdeaCard(title: "Local transportation", onTap: {})
    }
    .padding()
    .background(Color.founderBackground)
}
