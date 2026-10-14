//
//  EmptyStateView.swift
//  FoundersOS
//
//  Empty state view when no ideas exist.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    var buttonTitle: String? = nil
    var onButtonTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: FounderSpacing.lg) {
            Spacer()
            
            // Icon
            Image(systemName: "lightbulb")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.founderSecondaryText)
            
            // Text
            VStack(spacing: FounderSpacing.sm) {
                Text(title)
                    .font(FounderTypography.title2)
                    .foregroundColor(.founderPrimaryText)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(FounderTypography.body)
                    .foregroundColor(.founderSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            // Button
            if let buttonTitle = buttonTitle, let onButtonTap = onButtonTap {
                FounderButton(title: buttonTitle, action: onButtonTap)
                    .frame(maxWidth: 280)
            }
            
            Spacer()
        }
        .padding(FounderSpacing.xl)
    }
}

#Preview {
    EmptyStateView(
        title: "Your next company starts here.",
        subtitle: "Turn a rough idea into a real MVP.",
        buttonTitle: "Create your first idea",
        onButtonTap: {}
    )
    .background(Color.founderBackground)
}
