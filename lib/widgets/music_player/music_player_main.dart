import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/global_var/blur_radius.dart';
import 'package:juxt_music/global_var/music_player_appBar/music_player_icon_map.dart';
import 'package:juxt_music/states/selected_track_state.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/music_player/background/background_provider.dart';
import 'package:juxt_music/widgets/music_player/pages/control_page.dart';
import 'package:juxt_music/widgets/music_player/pages/lyric_page.dart';

/// Main [MusicPlayerMain] widget that returns the widgets that fill the music player
/// This widget utilizes a [Stack] to display it's children at multiple levels such
/// as background with [BackdropFilter] and the music player controls.
class MusicPlayerMain extends StatefulWidget {
  const MusicPlayerMain({super.key, required this.trackState});

  /// Selected track state. The preview is always available and detail enriches
  /// the UI after the lazy fetch completes.
  final SelectedTrackState trackState;

  @override
  State<MusicPlayerMain> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerMain> {
  /// button to check if music player is full screen or not
  bool isMusicPlayerFullScreen = false; // by default in mini-player mode

  /// [ColorScheme] to hold the color scheme of the current track's artwork
  ColorScheme? imageColorScheme;

  /// [ValueNotifier] to hold the current page
  ValueNotifier<int> pageNotifier = ValueNotifier<int>(1);

  /// [PageController] to handle change of pages
  late PageController _pageController;

  /// [bool] to hold value of track is playing or not.
  bool isPlaying = false;

  /// [bool] to ensure color scheme is ready before widgets are drawn
  bool isColorSchemeReady = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: pageNotifier.value);

    pageNotifier.addListener(changePage);
  }

  /// Function to change the page
  void changePage() {
    setState(() {
      _pageController.animateToPage(
        pageNotifier.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  /// Function to update the notifier so that the app bar can update
  void updateNotifier(int value) {
    if (value == pageNotifier.value) return;

    if (kDebugMode) print("Page changed manually to :$value");
    setState(() {
      pageNotifier.value = value;
    });
  }

  /// Function to update the music player state
  void updateMusicPlayerState() {
    setState(() {
      isMusicPlayerFullScreen = !isMusicPlayerFullScreen;
    });
  }

  @override
  void dispose() {
    pageNotifier.removeListener(changePage);
    _pageController.dispose();
    pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(BlurRadius.radius),
      child: Container(
        height: MediaQuery.sizeOf(context).height - 24, // Padding space
        width: isMusicPlayerFullScreen ? MediaQuery.sizeOf(context).width : 400,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(102),
          ),
          borderRadius: BorderRadius.circular(BlurRadius.radius),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image
            BackgroundProvider(
              trackState: widget.trackState,
              isFullScreen: isMusicPlayerFullScreen,
            ),

            // the player UI (note made only for small view first)
            isMusicPlayerFullScreen
                ? Row()
                : PageView(
                    controller: _pageController,
                    onPageChanged: (value) => updateNotifier(value),
                    children: [
                      // The lyrics page
                      LyricPage(),

                      // the music control page
                      ControlPage(
                        currentPosition: 0,
                        totalDuration: widget.trackState.duration.toDouble(),
                        isPlaying: isPlaying,
                        title: widget.trackState.title,
                        artist: widget.trackState.artistName,
                        playPause: () {
                          setState(() {
                            if (kDebugMode) print('Track is being: $isPlaying');
                            isPlaying = !isPlaying;
                          });
                        },
                        nextTrack: () {},
                        prevTrack: () {},
                        likeTrack: () {},
                      ),

                      // the queue page
                    ],
                  ),

            // Top App bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBarBlur(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),

                      IconButton(
                        onPressed: updateMusicPlayerState,
                        icon: const FaIcon(FontAwesomeIcons.chevronDown),
                      ),

                      const SizedBox(width: 15),

                      GlassAnim(
                        animationDirection: Axis.horizontal,
                        child: AppBarMain(
                          pageNotifier: pageNotifier,
                          children: MusicPlayerIconMap.musicPlayerIcons,
                          requiredWidth: 50,
                        ),
                      ),

                      const SizedBox(width: 15),

                      const Opacity(
                        opacity: 0,
                        child: IgnorePointer(
                          child: FaIcon(FontAwesomeIcons.chevronDown),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
