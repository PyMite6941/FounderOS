//
//  LoadingView.swift
//  FoundersOS
//
//  Animated loading view for AI thinking process.
//

import SwiftUI

struct LoadingView: View {
    @State private var animationPhase = 0
    @State private var opacity: Double = 0.3
    
    let currentStep: String
    
    private let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: FounderSpacing.xxl) {
            Spacer()
            
            // Animated Logo
            ZStack {
                // Background circle
                Circle()
                    .fill(Color.founderAccent.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                // Pulsing circle
                Circle()
                    .fill(Color.founderAccent.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .scaleEffect(animationPhase == 0 ? 1.0 : 1.2)
                    .opacity(animationPhase == 0 ? 1.0 : 0.6)
                
                // Logo
                Text("F")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.founderAccent)
            }
            
            // Title
            VStack(spacing: FounderSpacing.sm) {
                Text("Thinking about your idea...")
                    .font(FounderTypography.title2)
                    .foregroundColor(.founderPrimaryText)
                
                // Animated step text
                Text(currentStep)
                    .font(FounderTypography.subheadline)
                    .foregroundColor(.founderSecondaryText)
                    .multilineTextAlignment(.center)
                    .frame(height: 24)
                    .animation(.easeInOut(duration: 0.5), value: currentStep)
            }
            
            Spacer()
            
            // Loading indicator
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .founderAccent))
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.founderBackground)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.5)) {
                animationPhase = (animationPhase + 1) % 2
            }
        }
    }
}

#Preview {
    LoadingView(currentStep: "Understanding the problem")
}
