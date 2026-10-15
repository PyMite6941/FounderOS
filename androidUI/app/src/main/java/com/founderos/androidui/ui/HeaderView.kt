@Composable
fun HeaderView(
    title: String,
    subtitle: String? = null,
    onThemeToggle: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        backgroundColor = when (isSystemInDarkMode) {
            ColorPalette.darkBackground -> ColorPalette.darkCard
            else -> ColorPalette.lightBackground
        }
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.SpacedBy(4.dp),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.h6,
                color = when (isSystemInDarkMode) {
                    ColorPalette.lightPrimaryText -> ColorPalette.darkPrimaryText
                    else -> ColorPalette.darkPrimaryText
                }
            )

            when (subtitle != null) {
                Text(text = subtitle, style = MaterialTheme.typography.body2)
            }
        }

        Button(
            onClick = onThemeToggle,
            modifier = Modifier.align(Alignment.End),
            enabled = isSystemInDarkMode
        ) {
            Text("Light")
        }
    }
}
