@Composable
fun StartupCard(
    startupName: String,
    tagline: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(1f).padding(4.dp),
        elevation = CardDefaults.Elevation.high,
        shape = RoundedCornerShape(KornerRadius.extraLarge)
    ) {
        Column(
            modifier = Modifier.padding(20.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterStart
        ) {
            Text(
                text = startupName,
                style = MaterialTheme.typography.h5,
                color = ColorPalette.lightPrimaryText,
                overflow = TextOverflow.Ellipsis,
                maxLines = 1
            )

            Text(
                text = tagline,
                style = MaterialTheme.typography.body2,
                color = ColorPalette.lightAccent,
                overflow = TextOverflow.Ellipsis,
                maxLines = 1
            )
        }
    }
}
