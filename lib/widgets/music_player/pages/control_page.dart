import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/states/player_playback_state.dart';
import 'package:juxt_music/widgets/music_player/controller/player_controller.dart';
import 'package:juxt_music/widgets/music_track_bar/music_track_bar.dart';

/// This widget is the control page of the music player
/// It is a full screen widget that is displayed when the user
/// taps on the music player widget
class ControlPage extends StatelessWidget {
  const ControlPage({
    super.key,
    required this.playbackState,
    required this.nextTrack,
    required this.prevTrack,
    this.isTrackFavorite = false,
    required this.likeTrack,
  });

  final PlayerPlaybackState playbackState;
  final VoidCallback nextTrack;
  final VoidCallback prevTrack;
  final bool isTrackFavorite;
  final VoidCallback likeTrack;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playbackState,
      builder: (context, child) {
        final track = playbackState.currentTrack;
        final title = track?.title ?? '';
        final artist = track?.artistName ?? '';
        final isPlaying = playbackState.isPlaying;

        return Column(
          children: [
            // The empty spacing to view the track cover
            Flexible(flex: 1, child: Container()),

            // rest of the control UI
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.white.withAlpha(25),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Track information
                          infoRow(context, title, artist),

                          const SizedBox(height: 12),

                          // Music Track Bar
                          MusicTrackBar(playbackState: playbackState),

                          const SizedBox(height: 12),

                          // Track control widgets
                          PlayerController(buttons: {
                            FontAwesomeIcons.shuffle: () {},
                            FontAwesomeIcons.backward: prevTrack,
                            (isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play): playbackState.playPause,
                            FontAwesomeIcons.forward: nextTrack,
                            FontAwesomeIcons.repeat: () {},
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget infoRow(BuildContext context, String title, String artist) {
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

  Widget playerRow() {
    return Container(); // This widget shall be removed an a unified widget will be utilized.
  }
}
