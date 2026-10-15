package com.founderos.androidui.data

/**
 * Data model for AI-generated startup analysis.
 * Matches the backend API at POST /v1/analyze and iOS StartupAnalysis model.
 */
data class StartupAnalysis(
    val id: String,
    val startupName: String,
    val tagline: String = "",
    val problem: String,
    val targetUsers: List<String>,
    val solution: String,
    val mvpFeatures: List<String>,
    val businessModel: String,
    val validationQuestions: List<String>,
    val nextStep: String,
    val laterFeatures: List<String> = emptyList()
)