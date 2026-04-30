import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.title,
    required this.artist,
    required this.likeTrack,
    required this.isTrackFavorite,
  });

  final String title, artist;
  final VoidCallback likeTrack;
  final bool isTrackFavorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Artist text
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 12),
                overflow: TextOverflow.clip,
              ),
              const SizedBox(height: 4),
              Text(
                artist,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),

        // Like button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => likeTrack(),
            icon: Icon(
              isTrackFavorite ? Icons.star : Icons.star_border,
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
          ),
        ),

        // More options button
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).textTheme.titleMedium!.color,
          ),
        ),
      ],
    );
  }
}
