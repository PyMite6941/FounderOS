@Composable
fun TagPill(
    text: String,
    variant: TagPill.Variant = TagPill.Primary,
    modifier: Modifier = Modifier
) {
    val (backgroundColor, textColor) when (variant) {
        is TagPill.Primary -> (ColorPalette.accentDim, ColorPalette.accent)
        is TagPill.Secondary -> (ColorPalette.lightBorder, ColorPalette.lightPrimaryText)
    }

    Chip(
        modifier = modifier,
        backgroundColor = backgroundColor,
        label = {
            Text(
                text = text,
                color = textColor,
                style = MaterialTheme.typography.body1
            )
        }
    )
}

enum class TagVariant {
    Primary,
    Secondary
}
