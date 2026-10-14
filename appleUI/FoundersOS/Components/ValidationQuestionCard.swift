//
//  ValidationQuestionCard.swift
//  FoundersOS
//
//  Card component for validation interview questions.
//

import SwiftUI

struct ValidationQuestionCard: View {
    let number: Int
    let question: String
    
    var body: some View {
        HStack(alignment: .top, spacing: FounderSpacing.md) {
            // Number
            ZStack {
                Circle()
                    .fill(Color.founderAccent.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Text("\(number)")
                    .font(FounderTypography.headline)
                    .foregroundColor(.founderAccent)
            }
            
            // Question
            Text(question)
                .font(FounderTypography.body)
                .foregroundColor(.founderPrimaryText)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(FounderSpacing.md)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.medium)
    }
}

#Preview {
    VStack(spacing: 12) {
        ValidationQuestionCard(number: 1, question: "How do you currently find study partners?")
        ValidationQuestionCard(number: 2, question: "What is frustrating about your current solution?")
        ValidationQuestionCard(number: 3, question: "Would you pay for a better solution?")
    }
    .padding()
    .background(Color.founderBackground)
}
