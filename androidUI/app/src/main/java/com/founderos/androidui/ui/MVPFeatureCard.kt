@Composable
fun MVPFeatureCard(
    icon: String,
    title: String,
    description: String? = null,
    onClick: (() -> Unit)? = null,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(1f).padding(4.dp),
        elevation = CardDefaults.Elevation.high,
        shape = RoundedCornerShape(KornerRadius.medium)
    ) {
        Column(
            modifier = Modifier.padding(12.dp),
            verticalArrangement = Arrangement.SpaceBetween,
            horizontalAlignment = Alignment.Start
        ) {
            Row(
                horizontalArrangement = Arrangement.Start,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    Icons.Default.Event,
                    painterColor = ColorPalette.lightAccent,
                    contentDescription = null
                )

                Column(
                    modifier = Modifier.padding(8.dp, 0.dp, 0.dp),
                    verticalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = title,
                        style = MaterialTheme.typography.title3,
                        color = ColorPalette.lightPrimaryText,
                        overflow = TextOverflow.Ellipsis,
                        maxLines = 1
                    )

                    when (description != null) {
                        Text(text = description, style = MaterialTheme.typography.body2, overflow = TextOverflow.Ellipsis, maxLines = 1)
                    }
                }
            }

            when (onClick != null) {
                IconButton(onClick = onClick) {
                    Icon(Icons.Default.ArrowForward, contentDescription = null)
                }
            }
        }
    }
}
