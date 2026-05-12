import 'package:flutter/material.dart';
import 'package:juxt_music/states/player_playback_state.dart';
import 'package:juxt_music/widgets/music_player/pages/control_page.dart';
import 'package:juxt_music/widgets/music_player/pages/lyric_page.dart';
import 'package:juxt_music/widgets/music_player/pages/queue_page.dart';
import 'package:juxt_music/states/music_que_state.dart';

class DefaultPlayerPageView extends StatelessWidget {
  const DefaultPlayerPageView({
    super.key,
    required this.pageController,
    required this.pageNotifier,
    required this.playbackState,
    required this.musicQueState,
    required this.updateNotifier,
  });

  final PageController pageController;
  final ValueNotifier<int> pageNotifier;
  final PlayerPlaybackState playbackState;
  final MusicQueState musicQueState;
  final void Function(int) updateNotifier;

  @override
  Widget build(BuildContext context) {
    return PageView(
      key: const ValueKey('default-player-page-view'),
      controller: pageController,
      onPageChanged: updateNotifier,
      children: [
        LyricPage(),
        ControlPage(
          playbackState: playbackState,
          nextTrack: musicQueState.nextTrack,
          prevTrack: musicQueState.prevTrack,
          likeTrack: () {},
          isFullScreen: false,
        ),
        QueuePage(musicQueState: musicQueState),
      ],
    );
  }
}