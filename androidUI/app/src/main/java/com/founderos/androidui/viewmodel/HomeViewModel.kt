package com.founderos.androidui.viewmodel

import com.founderos.androidui.data.StartupAnalysis
import com.founderos.androidui.datastore.DataStore
import com.founderos.androidui.ui.results.tag
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.isDispatcher
import kotlinx.coroutines.withContext

/**
 * ViewModel for Home screen - corresponds to iOS HomeViewModel.
 * Manages idea text, loading state, and analysis state.
 */
class HomeViewModel : ObservableFlowUpdater() {

    // Published properties (observable UI state)
    var ideaText = ""
    var loadingState = when {
        isInitial -> LoadingState.Idle
        isLoading -> LoadingState.Loading(currentStep: LoadingSteps.messages[0])
        isSuccess -> LoadingState.Success
        isError -> LoadingState.Error(message = "Your idea is still here. Try again.")
    }
    var currentAnalysis: StartupAnalysis? = null
    var errorMessage: String? = null
    var showAnalysis = false
    var showCreateIdea = false
    var loadingStepIndex = 0

    // Private state
    private val _ideaChanges = mutableStateOf("")
    private var _loadingTimer: java.util.Timer? = null
    private val dataStore = DataStore()

    // Computed: whether analyze button should be enabled
    val canAnalyze: Boolean
        get() = ideaText.trim().length >= 10

    // Loading steps (corresponds to iOS LoadingSteps.messages)
    private val loadingSteps = listOf(
        "Understanding the problem",
        "Finding your users",
        "Designing the MVP",
        "Building your startup map"
    )

    // Initializer
    init {
        // Set up auto-advancing loading timer
        _loadingTimer = java.util.Timer().apply {
            scheduledAtFixedRate(
                0,
                2000,
                { advanceLoadingStep() }
            )
        }
    }

    // Published property wrappers using ObservableFlowUpdater pattern
    private val _ideaText = mutableStateOf(ideaText)
    val ideaTextFlow: Flow<String> = _ideaText.asFlow()

    // Accessors that update UI state
    set(value) {
        _ideaText.value = value
        // Update canAnalyze state implicitly
    }

    // Loading state management
    enum class LoadingState {
        Idle,
        Loading(currentStep: String),
        Success,
        Error(message: String)
    }

    fun startLoading() {
        loadingState = LoadingState.Loading(currentStep: currentStep)
        loadingStepIndex = 0
    }

    fun advanceLoadingStep() {
        if (loadingStepIndex < loadingSteps.size - 1) {
            loadingStepIndex++
            loadingState = LoadingState.Loading(currentStep: currentStep)
        }
    }

    fun stopLoading() {
        _loadingTimer?.cancel()
        _loadingTimer = null
        loadingState = LoadingState.Idle
    }

    // Core: analyze idea
    fun analyzeIdea(idea: String) async {
        loadingState = LoadingState.Loading(currentStep: currentStep)
        loadingStepIndex = 0
        errorMessage = null
        currentAnalysis = null

        try {
            // In real app, this would call the backend API
            // For now, simulate with local analysis
            val simulated = simulateAnalysis(idea)
            currentAnalysis = simulated
            loadingState = LoadingState.Success
            showAnalysis = true
        } catch (e: Exception) {
            loadingState = LoadingState.Error(message: "Something went wrong. Please try again.")
            errorMessage = "Something went wrong. Please try again."
        }
    }

    private fun simulateAnalysis(idea: String): StartupAnalysis {
        // Simple heuristic-based analysis matching iOS AIService behavior
        val ideaLower = idea.toLowerCase()

        val startupName = when {
            ideaLower.contains("ai") || ideaLower.contains("artificial intelligence") -> "AI-Powered Idea"
            ideaLower.contains("app") || ideaLower.contains("mobile") -> "Mobile App Idea"
            ideaLower.contains("web") || ideaLower.contains("website") -> "Web Platform"
            ideaLower.contains("finance") || ideaLower.contains("budget") -> "Finance Management"
            ideaLower.contains("health") || ideaLower.contains("medical") -> "Health Tech"
            else -> "Innovative Startup"
        }

        val tagline = when {
            ideaLower.contains("ai") -> "Intelligent solution for modern problems"
            ideaLower.contains("app") -> "App that solves a specific problem"
            ideaLower.contains("web") -> "Web-based solution for businesses"
            ideaLower.contains("finance") -> "Take control of your finances"
            ideaLower.contains("health") -> "Improving healthcare access"
            else -> ""
        }

        val problem = when {
            ideaLower.contains("ai") -> "Automate routine tasks and improve decision-making"
            ideaLower.contains("app") -> "Users need a mobile solution for daily tasks"
            ideaLower.contains("web") -> "Companies need an online presence and tools"
            ideaLower.contains("finance") -> "People struggle with budgeting and financial tracking"
            ideaLower.contains("health") -> "Patients face barriers to healthcare services"
            else -> idea
        }

        val solution = when {
            ideaLower.contains("ai") -> "AI platform that analyzes data and provides actionable insights"
            ideaLower.contains("app") -> "Native or cross-platform mobile application"
            ideaLower.contains("web") -> "Full-stack web application"
            ideaLower.contains("finance") -> "Personal finance management app"
            ideaLower.contains("health") -> "Digital health platform"
            else -> "Custom solution based on your unique idea"
        }

        val mvpFeatures = when {
            ideaLower.contains("ai") -> listOf("Dashboard", "Reporting", "User analytics")
            ideaLower.contains("app") -> listOf("User onboarding", "Core functionality", "Push notifications")
            ideaLower.contains("web") -> listOf("User authentication", "Dashboard", "API endpoints")
            ideaLower.contains("finance") -> listOf("Expense tracking", "Budget planning", "Reports")
            ideaLower.contains("health") -> listOf("Appointment scheduling", "Symptom tracker", "Provider directory")
            else -> listOf("Core feature", "User feedback loop", "Iterative development")
        }

        val businessModel = when {
            ideaLower.contains("ai") -> "SaaS subscription"
            ideaLower.contains("app") -> "Freemium"
            ideaLower.contains("web") -> "SaaS subscription"
            ideaLower.contains("finance") -> "Freemium"
            ideaLower.contains("health") -> "B2B subscription"
            else -> "Consulting"
        }

        val validationQuestions = when {
            ideaLower.contains("ai") -> listOf("What data sources do you have?", "How do you measure success?")
            ideaLower.contains("app") -> listOf("What problem does it solve?", "How will you acquire users?")
            ideaLower.contains("web") -> listOf("What's your pricing model?", "Who are your competitors?")
            ideaLower.contains("finance") -> listOf("What accounts do you track?", "How often do you review?")
            ideaLower.contains("health") -> listOf("HIPAA compliance?", "How do you ensure privacy?")
            else -> listOf("What makes this unique?", "Who is your target market?")
        }

        val targetUsers = when {
            ideaLower.contains("ai") -> listOf("Business professionals", "Entrepreneurs")
            ideaLower.contains("app") -> listOf("Mobile users", "Consumers")
            ideaLower.contains("web") -> listOf("Business owners", "Decision makers")
            ideaLower.contains("finance") -> listOf("Individuals", "Small business owners")
            ideaLower.contains("health") -> listOf("Patients", "Healthcare providers")
            else -> listOf("Early adopters", "Visionaries")
        }

        val solution = solution

        val nextStep = when {
            ideaLower.contains("ai") -> "Build MVP prototype"
            ideaLower.contains("app") -> "Design UI/UX prototype"
            ideaLower.contains("web") -> "Set up database and auth"
            ideaLower.contains("finance") -> "Set up account linking"
            ideaLower.contains("health") -> "Get regulatory clearance"
            else -> "Validate with potential users"
        }

        val laterFeatures = when {
            ideaLower.contains("ai") -> listOf("Advanced ML models", "Predictive analytics")
            ideaLower.contains("app") -> listOf("iOS and Android versions", "Monetization features")
            ideaLower.contains("web") -> listOf("Admin panel", "Integration marketplace")
            ideaLower.contains("finance") -> listOf("Investment tracking", "Tax assistance")
            ideaLower.contains("health") -> listOf("Telemedicine", "Wearable integration")
            else -> listOf("Scaling", "Product expansion")
        }

        return StartupAnalysis(
            id = java.util.UUID.randomUUID().toString(),
            startupName = startupName,
            tagline = tagline,
            problem = problem,
            targetUsers = targetUsers,
            solution = solution,
            mvpFeatures = mvpFeatures,
            businessModel = businessModel,
            validationQuestions = validationQuestions,
            nextStep = nextStep,
            laterFeatures = laterFeatures
        )
    }

    /** Current loading step string */
    val currentStep: String
        get() = if (loadingStepIndex < loadingSteps.size) loadingSteps[loadingStepIndex] else loadingSteps.last()

    // Clean up timer on disposal
    fun onCleared() {
        _loadingTimer?.cancel()
        _loadingTimer = null
    }
}

/**
 * ObservableFlowUpdater base class for managing ObservableFlow state.
 */
abstract class ObservableFlowUpdater {
    // Base class for flow-based observable state management
}

/** Extension property for mutableStateOf integration */
private val mutableStateOf by lazy {
    androidx.compose.runtime.MutableStateOf()
}