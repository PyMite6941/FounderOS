//
//  IdeaInput.swift
//  FoundersOS
//
//  Large text input for entering startup ideas.
//

import SwiftUI

struct IdeaInput: View {
    @Binding var text: String
    var placeholder: String = "Describe your startup idea..."
    var onSubmit: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: FounderSpacing.sm) {
            ZStack(alignment: .topLeading) {
                // Placeholder
                if text.isEmpty {
                    Text(placeholder)
                        .font(FounderTypography.body)
                        .foregroundColor(.founderSecondaryText)
                        .padding(.top, FounderSpacing.sm)
                        .padding(.leading, FounderSpacing.xs)
                }
                
                // Text Editor
                TextEditor(text: $text)
                    .font(FounderTypography.body)
                    .foregroundColor(.founderPrimaryText)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .focused($isFocused)
                    .frame(minHeight: 150, alignment: .topLeading)
                    .padding(.top, FounderSpacing.xs)
            }
        }
        .padding(FounderSpacing.md)
        .background(Color.founderCard)
        .cornerRadius(FounderCornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: FounderCornerRadius.large)
                .stroke(isFocused ? Color.founderAccent : Color.founderDivider, lineWidth: 1)
        )
        .onChange(of: text) { _, newValue in
            // Limit character count
            if newValue.count > AppConstants.maxIdeaLength {
                text = String(newValue.prefix(AppConstants.maxIdeaLength))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        IdeaInput(text: .constant(""))
        IdeaInput(text: .constant("An app that helps students find study partners."))
    }
    .padding()
    .background(Color.founderBackground)
}
