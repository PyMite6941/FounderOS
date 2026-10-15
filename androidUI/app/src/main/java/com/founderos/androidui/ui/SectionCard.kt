@Composable
fun SectionCard(
    title: String,
    description: String?,
    icon: String?,
    onClick: (() -> Unit)? = null,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(1f).padding(4.dp),
        elevation = CardDefaults.Elevation.medium,
        shape = RoundedCornerShape(KornerRadius.medium)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.SpaceBetween,
            horizontalAlignment = Alignment.Start
        ) {
            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.title4,
                    color = ColorPalette.lightPrimaryText
                )

                when (onClick != null) {
                    IconButton(onClick = onClick) {
                        Icon(Icons.Default.ArrowForward, contentDescription = null)
                    }
                }
            }

            when (description != null) {
                Text(
                    text = description,
                    style = MaterialTheme.typography.body2,
                    color = ColorPalette.lightSecondaryText,
                    overflow = TextOverflow.Ellipsis,
                    maxLines = 2
                )
            }
        }
    }
}
