package com.founderos.androidui.viewmodel

import com.founderos.androidui.data.StartupAnalysis
import com.founderos.androidui.datastore.DataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.withContext

/**
 * ViewModel for startup detail screens - corresponds to iOS StartupViewModel.
 * Manages startup idea data, sections navigation, and persistence operations.
 */
class StartupViewModel : ObservableFlowUpdater() {

    // Startup idea data (loaded from data store or created new)
    var startupIdea: StartupAnalysis? = DataStore().getStartupById("new") ?: null

    // Currently selected section index (0-5 corresponds to iOS 6 sections)
    var currentSection = 0

    // Published properties (observable UI state)
    private val _startupName = mutableStateOf<String?>("")
    private val _tagline = mutableStateOf<String?>("")
    private val _problem = mutableStateOf<String?>("")
    private val _targetUsers = mutableStateOf<List<String>>()
    private val _solution = mutableStateOf<String?>("")
    private val _mvpFeatures = mutableStateOf<List<String>>()
    private val _businessModel = mutableStateOf<String?>("")
    private val _validationQuestions = mutableStateOf<List<String>>()
    private val _nextStep = mutableStateOf<String?>("")
    private val _status = mutableStateOf<String>("Idea")

    // Published getters
    val startupName: String get() = _startupName.value ?: "New Startup"
    val tagline: String get() = _tagline.value ?: ""
    val problem: String get() = _problem.value ?: ""
    val targetUsers: List<String> get() = _targetUsers.value ?: emptyList()
    val solution: String get() = _solution.value ?: ""
    val mvpFeatures: List<String> get() = _mvpFeatures.value ?: emptyList()
    val businessModel: String get() = _businessModel.value ?: ""
    val validationQuestions: List<String> get() = _validationQuestions.value ?: emptyList()
    val nextStep: String get() = _nextStep.value ?: ""
    val status: String get() = _status.value ?: "Idea"

    // Sections (corresponds to iOS StartupViewModel.sections)
    private val sections = listOf(
        ("The Problem", "exclamationmark.triangle", "01"),
        ("Who is this for?", "person.2", "02"),
        ("The Solution", "lightbulb", "03"),
        ("Build This First", "rocket", "04"),
        ("How it makes money", "dollarsign.circle", "05"),
        ("Your Next Move", "arrow.right.circle", "06")
    )

    // Computed properties
    val startupNameUI: String
        get() = startupIdea?.startupName ?: "New Startup"

    val taglineUI: String
        get() = startupIdea?.tagline ?: ""

    val problemUI: String
        get() = startupIdea?.problem ?: ""

    val targetUsersUI: List<String>
        get() = startupIdea?.targetUsers ?: emptyList()

    val solutionUI: String
        get() = startupIdea?.solution ?: ""

    val mvpFeaturesUI: List<String>
        get() = startupIdea?.mvpFeatures ?: emptyList()

    val businessModelUI: String
        get() = startupIdea?.businessModel ?: ""

    val validationQuestionsUI: List<String>
        get() = startupIdea?.validationQuestions ?: emptyList()

    val nextStepUI: String
        get() = startupIdea?.nextStep ?: ""

    val statusUI: String
        get() = startupIdea?.status ?: "Idea"

    // Initializer
    init {
        // Load from data store if no idea exists, create default
        if (startupIdea == null) {
            DataStore().saveStartup(StartupAnalysis(
                id = "new",
                startupName = "",
                tagline = "",
                problem = "",
                targetUsers = emptyList(),
                solution = "",
                mvpFeatures = emptyList(),
                businessModel = "",
                validationQuestions = emptyList(),
                nextStep = "",
                laterFeatures = emptyList()
            ))
        }
    }

    // Navigation functions
    fun nextSection() {
        if (currentSection < sections.size - 1) {
            currentSection++
        }
    }

    fun previousSection() {
        if (currentSection > 0) {
            currentSection--
        }
    }

    fun goToSection(index: Int) {
        if (index >= 0 && index < sections.size) {
            currentSection = index
        }
    }

    // Save startup idea
    fun saveStartup() {
        if (startupIdea != null) {
            DataStore().saveStartup(startupIdea!!
        }
    }

    // Update status
    fun updateStatus(newStatus: String) {
        _status.value = newStatus
        if (startupIdea != null) {
            DataStore().saveStartup(startupIdea!!)
        }
    }

    // Delete startup
    fun deleteStartup() {
        DataStore().deleteStartup(startupIdea!!.id)
        startupIdea = null
        currentSection = 0
        reset()
    }

    // Reset view model state
    fun reset() {
        _startupName.value = ""
        _tagline.value = ""
        _problem.value = ""
        _targetUsers.value = emptyList()
        _solution.value = ""
        _mvpFeatures.value = emptyList()
        _businessModel.value = ""
        _validationQuestions.value = emptyList()
        _nextStep.value = ""
        _status.value = "Idea"
        currentSection = 0
    }

    // Update individual fields
    fun setStartupIdea(idea: StartupAnalysis?) {
        startupIdea = idea
        if (idea != null) {
            _startupName.value = idea.startupName
            _tagline.value = idea.tagline
            _problem.value = idea.problem
            _targetUsers.value = idea.targetUsers
            _solution.value = idea.solution
            _mvpFeatures.value = idea.mvpFeatures
            _businessModel.value = idea.businessModel
            _validationQuestions.value = idea.validationQuestions
            _nextStep.value = idea.nextStep
            _status.value = idea.status ?: "Idea"
        }
    }
}

// ObservableFlowUpdater base class (same as in HomeViewModel)
abstract class ObservableFlowUpdater {
}