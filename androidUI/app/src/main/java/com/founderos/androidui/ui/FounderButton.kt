package com.founderos.androidui.ui

import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.navigation.navigation
import com.founderos.androidui.R
import com.founderos.androidui.datastore.DataStore
import com.founderos.androidui.viewmodel.HomeViewModel
import com.founderos.androidui.viewmodel.StartupViewModel
import androidx.compose.foundation.Background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipShape
import androidx.compose.ui.graphics.ColorSwatch
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.pt
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.textDescription
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextStyle
import com.founderos.androidui.R.drawable.ic_launcher_foreground

@Composable
fun FounderButton(
    onClick: () -> Unit,
    text: String,
    variant: FounderButton.Variant = FounderButton.Primary,
    loading: Boolean = False,
    enabled: Boolean = True,
    modifier: Modifier = Modifier
) {
    val (color, textColor, backgroundColor) when (variant) {
        is FounderButton.Primary -> {
            (ColorPalette.lightBackground, ColorPalette.lightPrimaryText, ColorPalette.lightAccent) to
                (ColorPalette.darkBackground, ColorPalette.darkPrimaryText, ColorPalette.darkAccent)
        }
        is FounderButton.Secondary -> {
            (ColorPalette.lightCard, ColorPalette.lightPrimaryText, ColorPalette.lightBorder) to
                (ColorPalette.darkCard, ColorPalette.darkPrimaryText, ColorPalette.darkBorder)
        }
    }

    if (loading) {
        OutlinedButton(
            onClick = if (enabled) onClick else {},
            modifier = modifier.fillMaxWidth(),
            loading = True,
            title = { Text(text, color = textColor) }
        )
    } elif (!enabled) {
        OutlinedButton(
            onClick = {},
            modifier = modifier.fillMaxWidth(),
            title = { Text(text, color = textColor.copy(alpha = 0.5f)) }
        )
    } else {
        OutlinedButton(
            onClick = onClick,
            modifier = modifier.fillMaxWidth(),
            title = { Text(text, color = textColor) }
        )
    }
}

enum class FounderButtonVariant {
    Primary,
    Secondary
}
