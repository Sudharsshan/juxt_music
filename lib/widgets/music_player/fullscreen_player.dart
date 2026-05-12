import 'package:flutter/material.dart';
import 'package:juxt_music/widgets/music_player/background/background_provider.dart';
import 'package:juxt_music/widgets/music_player/pages/full_screen_page.dart';
import 'package:juxt_music/states/music_que_state.dart';
import 'package:juxt_music/states/player_playback_state.dart';

class FullScreenPlayer extends StatelessWidget {
  const FullScreenPlayer({
    super.key,
    required this.width,
    required this.height,
    required this.musicQueState,
    required this.playbackState,
    required this.onExitFullScreen,
  });

  final double width;
  final double height;
  final MusicQueState musicQueState;
  final PlayerPlaybackState playbackState;
  final VoidCallback onExitFullScreen;

  @override
  Widget build(BuildContext context) {
    final trackState = musicQueState.currentTrack!;

    return SizedBox(
      key: const ValueKey('fullscreen-player'),
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          BackgroundProvider(trackState: trackState, isFullScreen: true),
          FullscreenPage(
            musicQueState: musicQueState,
            playBackState: playbackState,
            availableWidth: width,
            availableHeight: height,
          ),
          Positioned(
            top: 30,
            right: 30,
            child: IconButton(
              onPressed: onExitFullScreen,
              tooltip: 'Exit fullscreen',
              icon: const Icon(Icons.close_fullscreen),
            ),
          ),
        ],
      ),
    );
  }
}