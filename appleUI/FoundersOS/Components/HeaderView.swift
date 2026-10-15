//
//  HeaderView.swift
//  FoundersOS
//
//  Reusable header component with title and optional action.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    var subtitle: String? = nil
    var rightAction: (() -> Void)? = nil
    var rightActionIcon: String = "plus"
    
    var body: some View {
        HStack(alignment: .bottom) {
            // Left: Title and subtitle
            VStack(alignment: .leading, spacing: FounderSpacing.xxs) {
                Text(title)
                    .font(FounderTypography.largeTitle)
                    .foregroundColor(.founderPrimaryText)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(FounderTypography.subheadline)
                        .foregroundColor(.founderSecondaryText)
                }
            }
            
            Spacer()
            
            // Right: Action button
            if let rightAction = rightAction {
                Button(action: rightAction) {
                    Image(systemName: rightActionIcon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.founderAccent)
                        .frame(width: 36, height: 36)
                        .background(Color.founderAccent.opacity(0.1))
                        .cornerRadius(FounderCornerRadius.small)
                }
            }
        }
        .padding(.horizontal, FounderSpacing.lg)
        .padding(.top, FounderSpacing.lg)
        .padding(.bottom, FounderSpacing.md)
    }
}

#Preview {
    VStack {
        HeaderView(
            title: "FounderOS",
            subtitle: "Turn an idea into something real.",
            rightAction: {}
        )
        
        Spacer()
    }
    .background(Color.founderBackground)
}
