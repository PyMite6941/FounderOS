//
//  FounderButton.swift
//  FoundersOS
//
//  Primary button component with subtle press animation.
//

import SwiftUI

struct FounderButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var style: ButtonStyle = .primary
    
    enum ButtonStyle {
        case primary
        case secondary
        case tertiary
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            guard !isDisabled && !isLoading else { return }
            action()
        }) {
            HStack(spacing: FounderSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                }
                
                Text(title)
                    .font(FounderTypography.headline)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, FounderSpacing.md)
            .padding(.horizontal, FounderSpacing.lg)
            .background(backgroundColor)
            .cornerRadius(FounderCornerRadius.medium)
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: FounderAnimation.quick), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .disabled(isDisabled || isLoading)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .founderAccent
        case .secondary:
            return .founderCard
        case .tertiary:
            return .clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .founderPrimaryText
        case .tertiary:
            return .founderAccent
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FounderButton(title: "Primary Button", action: {})
        FounderButton(title: "Secondary Button", action: {}, style: .secondary)
        FounderButton(title: "Disabled", action: {}, isDisabled: true)
        FounderButton(title: "Loading", action: {}, isLoading: true)
    }
    .padding()
    .background(Color.founderBackground)
}
