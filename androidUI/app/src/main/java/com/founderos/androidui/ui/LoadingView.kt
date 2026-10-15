@Composable
fun LoadingView(show: Boolean = true, text: String = "Analyzing...") {
    if (show) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            CircularProgressIndicator(modifier = Modifier.size(40.dp))
            Text(
                text = text,
                modifier = Modifier.offset(CoordinatePathOffset(0f, 50.dp)),
                color = ColorPalette.lightSecondaryText,
                style = MaterialTheme.typography.body2
            )
        }
    }
}
