//
//  ErrorStateView.swift
//  FoundersOS
//
//  Error state view when AI request fails.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: FounderSpacing.lg) {
            Spacer()
            
            // Icon
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.founderError)
            
            // Text
            VStack(spacing: FounderSpacing.sm) {
                Text("Something went wrong.")
                    .font(FounderTypography.title2)
                    .foregroundColor(.founderPrimaryText)
                
                Text(message)
                    .font(FounderTypography.body)
                    .foregroundColor(.founderSecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            // Retry button
            if let retryAction = retryAction {
                FounderButton(title: "Try Again", action: retryAction)
                    .frame(maxWidth: 200)
            }
            
            Spacer()
        }
        .padding(FounderSpacing.xl)
    }
}

#Preview {
    ErrorStateView(
        message: "Your idea is still here. Try again.",
        retryAction: {}
    )
    .background(Color.founderBackground)
}
