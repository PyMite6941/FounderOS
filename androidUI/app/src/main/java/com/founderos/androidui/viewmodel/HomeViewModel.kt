package com.founderos.androidui.viewmodel

import com.founderos.androidui.data.StartupAnalysis
import com.founderos.androidui.network.AIService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

data class HomeUiState(
    val ideaText: String = "",
    val loadingState: HomeLoadingState = HomeLoadingState.Idle,
    val currentAnalysis: StartupAnalysis? = null,
    val errorMessage: String? = null,
    val showAnalysis: Boolean = false,
)

sealed class HomeLoadingState {
    object Idle : HomeLoadingState()
    object Loading : HomeLoadingState()
    object Success : HomeLoadingState()
    data class Error(val message: String) : HomeLoadingState()
}

class HomeViewModel {
    private val mutableState = MutableStateFlow(HomeUiState())
    val state: StateFlow<HomeUiState> = mutableState.asStateFlow()

    val canAnalyze: Boolean
        get() = mutableState.value.ideaText.trim().length >= 10

    fun updateIdeaText(idea: String) {
        mutableState.value = mutableState.value.copy(ideaText = idea)
    }

    suspend fun analyzeIdea(idea: String = mutableState.value.ideaText) {
        val trimmedIdea = idea.trim()
        if (trimmedIdea.length < 10) {
            val message = "Please describe your idea in more detail."
            mutableState.value = mutableState.value.copy(
                loadingState = HomeLoadingState.Error(message),
                errorMessage = message,
            )
            return
        }

        mutableState.value = mutableState.value.copy(
            loadingState = HomeLoadingState.Loading,
            currentAnalysis = null,
            errorMessage = null,
            showAnalysis = false,
        )

        try {
            val analysis = AIService.analyzeIdea(trimmedIdea)
            mutableState.value = mutableState.value.copy(
                loadingState = HomeLoadingState.Success,
                currentAnalysis = analysis,
                errorMessage = null,
                showAnalysis = true,
            )
        } catch (error: Exception) {
            val message = error.message ?: "Analysis could not be saved. Please try again."
            mutableState.value = mutableState.value.copy(
                loadingState = HomeLoadingState.Error(message),
                errorMessage = message,
            )
        }
    }
}

abstract class ObservableFlowUpdater
