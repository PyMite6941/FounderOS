package com.founderos.androidui.datastore

/**
 * Data store for managing startup ideas persistently.
 * Corresponds to iOS PersistenceService with SwiftData.
 */
object DataStore {
    // In-memory storage (replace with Room database or Room in production)
    private val startupIdeas = mutableListOf<StartupAnalysis>()
    private var lastId = 0

    /** Add a new startup analysis */
    fun saveStartup(analysis: StartupAnalysis) {
        startupIdeas.add(analysis)
        lastId = analysis.id.toInt().coerceAtLeast(++lastId)
    }

    /** Get all startups */
    fun getAllStartups(): List<StartupAnalysis> = startupIdeas

    /** Get a startup by ID */
    fun getStartupById(id: String): StartupAnalysis? {
        return startupIdeas.find { it.id == id }
    }

    /** Update a startup analysis */
    fun updateStartup(analysis: StartupAnalysis) {
        val index = startupIdeas.indexOfFirst { it.id == analysis.id }
        if (index >= 0) {
            startupIdeas[index] = analysis
        }
    }

    /** Delete a startup analysis */
    fun deleteStartup(id: String) {
        startupIdeas.removeAll { it.id == id }
    }

    /** Check if an idea already exists (de-dupe by idea text) */
    fun ideaExists(rawIdea: String): Boolean = startupIdeas.any { it.problem.contains(rawIdea, ignoreCase = true) || it.solution.contains(rawIdea, ignoreCase = true) }
}