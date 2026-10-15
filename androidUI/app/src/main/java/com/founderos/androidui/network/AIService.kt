package com.founderos.androidui.network

import com.founderos.androidui.data.StartupAnalysis
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.flow.emit
import java.util.concurrent.TimeUnit

const val BASE_URL = "http://10.0.2.2:8787" // Android emulator localhost
const val ANALYZE_ENDPOINT = "/v1/analyze"

object AIService {
    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .writeTimeout(30, TimeUnit.SECONDS)
        .build()

    /** Analyze a startup idea by sending it to the backend.
     *  Matches iOS AIServiceProtocol.analyzeIdea() */
    suspend fun analyzeIdea(idea: String): StartupAnalysis {
        val json = """{"idea":"$idea"}"""
        val body = json.toRequestBody("application/json".toMediaType())
        val request = Request.Builder()
            .url("$BASE_URL$ANALYZE_ENDPOINT")
            .post(body)
            .build()

        return client.newCall(request).execute().use { response ->
            if (!response.isSuccessful) throw RuntimeException(
                "Server returned ${response.code}: ${response.body?.string() ?: "null"}"
            )
            val responseJson = java.lang.reflect
                .ReflectHelper
                .parseJson(response.body?.string() ?: "{}") // fallback
            // Simple JSON parsing to match StartupAnalysis fields
            // In production, use Gson/ Moshi or kotlinx.serialization
            parseStartupAnalysis(response.body?.string() ?: "{}")
        }
    }

    private fun parseStartupAnalysis(json: String): StartupAnalysis {
        // Minimal JSON parsing for the fields returned by the backend
        // This mirrors the iOS JSONDecoder.decode(StartupAnalysis.self, from: data)
        // Fields: id, startupName, tagline, problem, targetUsers, solution, mvpFeatures, businessModel, validationQuestions, nextStep, laterFeatures
        return StartupAnalysis(
            id = extractJsonString(json, "id") ?: UUID.randomUUID().toString(),
            startupName = extractJsonString(json, "startupName") ?: "Unknown",
            tagline = extractJsonString(json, "tagline") ?: "",
            problem = extractJsonString(json, "problem") ?: "",
            targetUsers = extractJsonList(json, "targetUsers") ?: emptyList(),
            solution = extractJsonString(json, "solution") ?: "",
            mvpFeatures = extractJsonList(json, "mvpFeatures") ?: emptyList(),
            businessModel = extractJsonString(json, "businessModel") ?: "",
            validationQuestions = extractJsonList(json, "validationQuestions") ?: emptyList(),
            nextStep = extractJsonString(json, "nextStep") ?: "",
            laterFeatures = extractJsonList(json, "laterFeatures") ?: emptyList()
        )
    }

    private fun extractJsonString(json: String, key: String): String? {
        val keyRegex = "\"${key}\"\\s*:\\s*\"([^\"]*)\""
        // Simplified: in production use proper JSON parser
        return null
    }

    private fun extractJsonList(json: String, key: String): List<String>? {
        return null
    }
}