package com.founderos.androidui

/**
 * Color palette for FounderOS Android app.
 * Light and dark mode support following Material Design guidelines.
 * Corresponds to iOS FounderOS Constants.swift color system.
 */
object ColorPalette {
    // Light mode colors
    const val lightBackground = "#F5F5F7"
    const val lightPrimaryText = "#1D1D1F"
    const val lightSecondaryText = "#6E6E73"
    const val lightCard = "#FFFFFF"
    const val lightAccent = "#007AFF"
    const val lightDivider = "#E5E5EA"

    // Dark mode colors
    const val darkBackground = "#000000"
    const val darkPrimaryText = "#F5F5F7"
    const val darkSecondaryText = "#98989D"
    const val darkCard = "#1C1C1E"
    const val darkAccent = "#0A84FF"
    const val darkDivider = "#38383A"

    // Status colors
    const val statusValidating = "#FF9500"
    const val statusBuilding = "#34C759"
    const val statusError = "#FF3B30"

    // Generate Android Color int from hex string
    fun intLight(hex: String): Int = android.graphics.Color.parseColor(hex)
    fun intDark(hex: String): Int = android.graphics.Color.parseColor(hex)
}

/**
 * Typography system for FounderOS Android app.
 * Corresponds to iOS FounderTypography system.
 */
object Typography {
    // Font weights
    const val light = android.graphics.Typeface.NORMAL
    const val regular = android.graphics.Typeface.NORMAL
    const val medium = android.graphics.Typeface.BOLD
    const val semibold = android.graphics.Typeface.BOLD
    const val bold = android.graphics.Typeface.BOLD

    // Text sizes in sp (corresponds to iOS FounderTypography point sizes)
    const val displayLarge = 57f
    const val displayMedium = 45f
    const val displaySmall = 36f
    const val headline = 32f
    const val titleLarge = 28f
    const val titleMedium = 22f
    const val titleSmall = 20f
    const val bodyLarge = 17f
    const val bodyMedium = 16f
    const val bodySmall = 14f
    const val labelLarge = 13f
    const val labelMedium = 12f
    const val labelSmall = 11f
    const val headline6 = 20f // Material Design 3 equivalent
    const val body2 = 16f // Material Design 3 equivalent
    const val body1 = 18f // Material Design 3 equivalent
}

/**
 * Spacing system for FounderOS Android app.
 * Corresponds to iOS FounderSpacing system.
 */
object Spacing {
    const val xxs = 4f
    const val xs = 8f
    const val sm = 12f
    const val md = 16f
    const val lg = 20f
    const val xl = 24f
    const val xxl = 32f
    const val xxxl = 48f
}

/**
 * Corner radius values for FounderOS Android app.
 * Corresponds to iOS FounderCornerRadius system.
 */
object CornerRadius {
    const val small = 12f
    const val medium = 16f
    const val large = 20f
    const val extraLarge = 24f
    const val full = 9999f
}

/**
 * Animation durations for FounderOS Android app.
 * Corresponds to iOS FounderAnimation system.
 */
object Animation {
    const val quick = 0.2f
    const val standard = 0.3f
    const val slow = 0.5f
    const val spring = 0.4f
}