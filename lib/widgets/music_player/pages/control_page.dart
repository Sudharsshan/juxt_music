import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/states/player_playback_state.dart';
import 'package:juxt_music/widgets/music_player/controller/player_controller.dart';
import 'package:juxt_music/widgets/music_player/info_row.dart';
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
    this.isFullScreen = false,
  });

  final PlayerPlaybackState playbackState;
  final VoidCallback nextTrack;
  final VoidCallback prevTrack;
  final bool isTrackFavorite;
  final VoidCallback likeTrack;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playbackState,
      builder: (context, child) {
        final track = playbackState.currentTrack;
        final title = track?.title ?? '';
        final artist = track?.artistName ?? '';
        final isPlaying = playbackState.isPlaying;
        final double blurValue = isFullScreen? 0 : 12;

        return Column(
          children: [
            // The empty spacing to view the track cover
            isFullScreen? SizedBox.shrink() :  Flexible(flex: 1, child: Container()),

            // rest of the control UI
            Flexible(
              flex: 1,
              child: Container(
                color: isFullScreen? Colors.transparent : Colors.white.withAlpha(25),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Track information
                          InfoRow(
                            title: title,
                            artist: artist,
                            likeTrack: () {},
                            isTrackFavorite: isTrackFavorite,
                          ),

                          const SizedBox(height: 12),

                          // Music Track Bar
                          MusicTrackBar(playbackState: playbackState),

                          const SizedBox(height: 12),

                          // Track control widgets
                          PlayerController(
                            buttons: {
                              FontAwesomeIcons.shuffle: () {},
                              FontAwesomeIcons.backward: prevTrack,
                              (isPlaying
                                      ? FontAwesomeIcons.pause
                                      : FontAwesomeIcons.play):
                                  playbackState.playPause,
                              FontAwesomeIcons.forward: nextTrack,
                              FontAwesomeIcons.repeat: () {},
                            },
                          ),
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
}
