package com.founderos.androidui.network

import com.founderos.androidui.data.StartupAnalysis
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

const val BASE_URL = "http://10.0.2.2:8000"
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
        val json = JSONObject()
            .put("idea", idea)
            .put("client", "android")
            .toString()
        val body = json.toRequestBody("application/json".toMediaType())
        val request = Request.Builder()
            .url("$BASE_URL$ANALYZE_ENDPOINT")
            .post(body)
            .build()

        return withContext(Dispatchers.IO) {
            client.newCall(request).execute().use { response ->
                val responseBody = response.body?.string().orEmpty()
                if (!response.isSuccessful) {
                    throw IOException("Server returned ${response.code}: $responseBody")
                }
                val analysis = JSONObject(responseBody).optJSONObject("analysis")
                    ?: throw IOException("Server response did not include an analysis.")
                parseStartupAnalysis(analysis)
            }
        }
    }

    private fun parseStartupAnalysis(json: JSONObject): StartupAnalysis {
        return StartupAnalysis(
            id = json.getString("id"),
            startupName = json.getString("startupName"),
            tagline = json.optString("tagline"),
            problem = json.getString("problem"),
            targetUsers = json.getJSONArray("targetUsers").toStringList(),
            solution = json.getString("solution"),
            mvpFeatures = json.getJSONArray("mvpFeatures").toStringList(),
            businessModel = json.getString("businessModel"),
            validationQuestions = json.getJSONArray("validationQuestions").toStringList(),
            nextStep = json.getString("nextStep"),
            laterFeatures = json.optJSONArray("laterFeatures")?.toStringList().orEmpty(),
        )
    }

    private fun org.json.JSONArray.toStringList(): List<String> =
        (0 until length()).map { getString(it) }
}