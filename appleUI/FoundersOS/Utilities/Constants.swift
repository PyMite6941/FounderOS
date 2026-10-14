//
//  Constants.swift
//  FoundersOS
//
//  Design system constants following Apple Human Interface Guidelines.
//

import SwiftUI

// MARK: - Colors

extension Color {
    // MARK: Primary Colors
    /// Light mode background
    static let founderBackground = Color(light: Color(hex: "F5F5F7"), dark: Color(hex: "000000"))
    
    /// Primary text color
    static let founderPrimaryText = Color(light: Color(hex: "1D1D1F"), dark: Color(hex: "F5F5F7"))
    
    /// Secondary text color
    static let founderSecondaryText = Color(light: Color(hex: "6E6E73"), dark: Color(hex: "98989D"))
    
    /// Card background
    static let founderCard = Color(light: Color.white, dark: Color(hex: "1C1C1E"))
    
    /// Accent color (iOS Blue)
    static let founderAccent = Color(light: Color(hex: "007AFF"), dark: Color(hex: "0A84FF"))
    
    // MARK: Semantic Colors
    /// Success color
    static let founderSuccess = Color(hex: "34C759")
    
    /// Warning color
    static let founderWarning = Color(hex: "FF9500")
    
    /// Error color
    static let founderError = Color(hex: "FF3B30")
    
    /// Divider color
    static let founderDivider = Color(light: Color(hex: "E5E5EA"), dark: Color(hex: "38383A"))
    
    // MARK: Status Colors
    /// Idea status color
    static let statusIdea = Color(hex: "8E8E93")
    
    /// Validating status color
    static let statusValidating = Color(hex: "FF9500")
    
    /// Building status color
    static let statusBuilding = Color(hex: "34C759")
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Initialize color with light/dark mode support
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

// MARK: - Typography

struct FounderTypography {
    // MARK: Font Styles
    
    /// Large title - .largeTitle (34pt)
    static let largeTitle = Font.largeTitle
    static let largeTitleWeight: Font = .largeTitle.weight(.bold)
    
    /// Title 1 - .title (28pt)
    static let title1 = Font.title
    
    /// Title 2 - .title2 (22pt)
    static let title2 = Font.title2
    static let title2Weight: Font = .title2.weight(.semibold)
    
    /// Title 3 - .title3 (20pt)
    static let title3 = Font.title3
    
    /// Headline - .headline (17pt semibold)
    static let headline = Font.headline
    
    /// Body - .body (17pt)
    static let body = Font.body
    
    /// Callout - .callout (16pt)
    static let callout = Font.callout
    
    /// Subheadline - .subheadline (15pt)
    static let subheadline = Font.subheadline
    
    /// Footnote - .footnote (13pt)
    static let footnote = Font.footnote
    
    /// Caption 1 - .caption (12pt)
    static let caption = Font.caption
    
    /// Caption 2 - .caption2 (11pt)
    static let caption2 = Font.caption2
}

// MARK: - Spacing

struct FounderSpacing {
    /// Extra small spacing: 4pt
    static let xxs: CGFloat = 4
    
    /// Small spacing: 8pt
    static let xs: CGFloat = 8
    
    /// Medium spacing: 12pt
    static let sm: CGFloat = 12
    
    /// Default spacing: 16pt
    static let md: CGFloat = 16
    
    /// Large spacing: 20pt
    static let lg: CGFloat = 20
    
    /// Extra large spacing: 24pt
    static let xl: CGFloat = 24
    
    /// 2x Extra large spacing: 32pt
    static let xxl: CGFloat = 32
    
    /// 3x Extra large spacing: 48pt
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radius

struct FounderCornerRadius {
    /// Small radius: 12pt
    static let small: CGFloat = 12
    
    /// Medium radius: 16pt
    static let medium: CGFloat = 16
    
    /// Large radius: 20pt
    static let large: CGFloat = 20
    
    /// Extra large radius: 24pt
    static let extraLarge: CGFloat = 24
    
    /// Full radius (circular): 9999
    static let full: CGFloat = 9999
}

// MARK: - Shadows

struct FounderShadow {
    /// Light shadow
    static func light() -> some View {
        Color.black.opacity(0.05)
    }
    
    /// Medium shadow
    static func medium() -> some View {
        Color.black.opacity(0.1)
    }
    
    /// Heavy shadow
    static func heavy() -> some View {
        Color.black.opacity(0.15)
    }
}

// MARK: - Animation Durations

struct FounderAnimation {
    /// Quick animation: 0.2s
    static let quick: Double = 0.2
    
    /// Default animation: 0.3s
    static let standard: Double = 0.3
    
    /// Slow animation: 0.5s
    static let slow: Double = 0.5
    
    /// Spring animation
    static let spring = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8)
    
    /// Ease in-out animation
    static let easeInOut = SwiftUI.Animation.easeInOut(duration: standard)
}

// MARK: - App Constants

struct AppConstants {
    /// App name
    static let appName = "FounderOS"
    
    /// App tagline
    static let appTagline = "Turn an idea into something real."
    
    /// App version
    static let appVersion = "1.0"
    
    /// Maximum characters for idea input
    static let maxIdeaLength = 500
    
    /// Minimum characters for idea input
    static let minIdeaLength = 10
    
    /// Example ideas for quick start
    static let exampleIdeas = [
        "Study buddy",
        "Food waste",
        "Local transportation",
        "Student finance"
    ]
    
    /// Validation goal description
    static let validationGoal = "Talk to 5 potential users"
}
