//
//  TagPill.swift
//  FoundersOS
//
//  Small pill component for displaying tags and user segments.
//

import SwiftUI

struct TagPill: View {
    let text: String
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: {
            onTap?()
        }) {
            Text(text)
                .font(FounderTypography.footnote)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .founderPrimaryText)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, FounderSpacing.sm)
                .padding(.vertical, FounderSpacing.xs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(isSelected ? Color.founderAccent : Color.founderCard)
                .cornerRadius(FounderCornerRadius.full)
                .overlay(
                    RoundedRectangle(cornerRadius: FounderCornerRadius.full)
                        .stroke(isSelected ? Color.clear : Color.founderDivider, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TagPillGroup: View {
    let tags: [String]
    var selectedTags: [String] = []
    var onTagTap: ((String) -> Void)? = nil
    
    var body: some View {
        FlowLayout(spacing: FounderSpacing.xs) {
            ForEach(tags, id: \.self) { tag in
                TagPill(
                    text: tag,
                    isSelected: selectedTags.contains(tag),
                    onTap: {
                        onTagTap?(tag)
                    }
                )
            }
        }
    }
}

/// Custom flow layout for wrapping tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )

        for (index, subview) in subviews.enumerated() {
            let point = CGPoint(
                x: bounds.minX + result.positions[index].x,
                y: bounds.minY + result.positions[index].y
            )
            // Propose the row width so a single long tag can wrap onto
            // multiple lines instead of being clipped off-screen.
            subview.place(
                at: point,
                anchor: .topLeading,
                proposal: ProposedViewSize(width: bounds.width, height: nil)
            )
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                // Measure at the full row width so a single over-long tag
                // wraps onto multiple lines and reserves the height it needs.
                let measured = subview.sizeThatFits(
                    ProposedViewSize(width: maxWidth, height: nil)
                )
                let subWidth = min(measured.width, maxWidth)

                if x > 0 && x + subWidth > maxWidth {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, measured.height)
                x += subWidth + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + rowHeight)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            TagPill(text: "Students")
            TagPill(text: "13-22", isSelected: true)
            TagPill(text: "Exam Prep")
        }
        
        TagPillGroup(tags: ["Students", "Teachers", "Parents", "Schools"], selectedTags: ["Students", "Schools"])
    }
    .padding()
    .background(Color.founderBackground)
}
