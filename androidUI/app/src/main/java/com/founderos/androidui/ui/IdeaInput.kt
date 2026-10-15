@Composable
fun IdeaInput(
    value: String,
    onValueChanged: (String) -> Unit,
    maxChars: Int = 500,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = value,
        onValueChanged = onValueChanged,
        label = { Text("What are you thinking about?") },
        maxChars = maxChars,
        supportingText = if (value.isNotEmpty()) {
            Text(
                text = "${value.length}/${maxChars} chars",
                style = MaterialTheme.typography.caption,
                color = ColorPalette.lightSecondaryText
            )
        } else {
            null
        },
        trailingIcon = {
            if (value.isNotEmpty()) {
                IconButton(onClick = { /* clear */ }) {
                    Icon(Icons.Default.Close, contentDescription = null)
                }
            } else {
                null
            }
        },
        modifier = modifier.fillMaxWidth()
    )
}
