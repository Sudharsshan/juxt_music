import 'package:flutter/material.dart';
import 'package:gradient_blur/gradient_blur.dart';

/// This widget is the control page of the music player
/// It is a full screen widget that is displayed when the user
/// taps on the music player widget
class ControlPage extends StatelessWidget {
  const ControlPage({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.isPlaying,
    required this.title,
    required this.artist,
    required this.playPause,
    required this.nextTrack,
    required this.prevTrack,
    this.isTrackFavorite = false,
    required this.likeTrack,
  });

  final double currentPosition;
  final double totalDuration;
  final bool isPlaying;
  final String title, artist;
  final Function playPause;
  final Function nextTrack;
  final Function prevTrack;
  final bool isTrackFavorite;
  final Function likeTrack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The empty spacing to view the track cover
        Flexible(flex: 1, child: Container()),

        // rest of the control UI
        Flexible(
          flex: 1,
          child: GradientBlur(
            child: Column(
              children: [
                // Featured artist SECTION COMMING SOON

                // Info Row
                infoRow(context),

                // Player Row
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget infoRow(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            // Title and Artist text
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontSize: 12),
            ),
            Text(
              artist,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontSize: 12),
            ),
          ],
        ),

        const Spacer(),

        // Like button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: likeTrack(),
            icon: Icon(
              isTrackFavorite ? Icons.star : Icons.star_border,
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
        ),

        // More options button
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget playerRow() {
    return Container(); // This widget shall be removed an a unified widget will be utilized.
  }
}
