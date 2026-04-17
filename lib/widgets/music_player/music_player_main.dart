import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/global_var/artwork_sizes/artwork_sizes.dart';
import 'package:juxt_music/global_var/blur_radius.dart';
import 'package:juxt_music/global_var/music_player_appBar/music_player_icon_map.dart';
import 'package:juxt_music/models/audius_model.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/cover_art/cover_box_main.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/music_player/pages/control_page.dart';
import 'package:juxt_music/widgets/music_player/pages/lyric_page.dart';

/// Main [MusicPlayerMain] widget that returns the widgets that fill the music player
/// This widget utilizes a [Stack] to display it's children at multiple levels such
/// as background with [GradientBlur] and the music player controls.
class MusicPlayerMain extends StatefulWidget {
  const MusicPlayerMain({super.key, required this.trackDetails});

  /// A [AudiusModel] variable to hold the track details to show
  final AudiusModel trackDetails;

  @override
  State<MusicPlayerMain> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerMain> {
  /// button to check if music player is full screen or not
  bool musicPlayerFullScreen = false; // by default in mini-player mode

  /// [ColorScheme] to hold the color scheme of the current track's artwork
  ColorScheme? imageColorScheme;

  /// [ValueNotifier] to hold the current page
  ValueNotifier<int> pageNotifier = ValueNotifier<int>(1);

  /// [PageController] to handle change of pages
  late PageController _pageController;

  /// [bool] to hold value of track is playing or not.
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    updateColorScheme();

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

  /// Function to update the color scheme of the current track's artwork
  Future<void> updateColorScheme() async {
    final NetworkImage provider = NetworkImage(
      widget.trackDetails.getArtwork(ArtworkSize.large)!,
    );

    /// Generate a scheme based on the seed color of the image
    final ColorScheme newScheme = await ColorScheme.fromImageProvider(
      provider: provider,
      brightness: MediaQuery.of(context).platformBrightness,
    );

    if (mounted) {
      setState(() {
        imageColorScheme = newScheme;
      });
    }
  }

  /// Function to update the music player state
  void updateMusicPlayerState() {
    setState(() {
      musicPlayerFullScreen = !musicPlayerFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: musicPlayerFullScreen ? MediaQuery.sizeOf(context).width : 400,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(40),
        ),
        borderRadius: BorderRadius.circular(BlurRadius.radius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background image
          backgroundBuilder(
            musicPlayerFullScreen,
            musicPlayerFullScreen
                ? Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CoverBoxMain(
                          imagePath: widget.trackDetails.getArtwork(
                            ArtworkSize.large,
                          )!,
                          isNetwork: true,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(color: imageColorScheme!.surface),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CoverBoxMain(
                          imagePath: widget.trackDetails.getArtwork(
                            ArtworkSize.large,
                          )!,
                          isNetwork: true,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(color: imageColorScheme!.surface),
                      ),
                    ],
                  ),
          ),

          // the player UI (note made only for small view first)
          musicPlayerFullScreen
              ? PageView(
                  controller: _pageController,
                  children: [
                    // The lyrics page
                    LyricPage(),

                    // the music control page
                    ControlPage(
                      currentPosition: 0,
                      totalDuration: 0.00,
                      isPlaying: isPlaying,
                      title: widget.trackDetails.title,
                      artist: widget.trackDetails.artist,
                      playPause: () {},
                      nextTrack: () {},
                      prevTrack: () {},
                      likeTrack: () {},
                    ),

                    // the queue page
                  ],
                )
              : Row(),

          // Top App bar
          Positioned(
            top: 0,
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
    );
  }

  Widget backgroundBuilder(bool isFullScreen, Widget backgroundImage) {
    if (isFullScreen) {
      return Positioned.fill(top: 0, left: 0, child: backgroundImage);
    } else {
      return Positioned(top: 0, left: 0, child: backgroundImage);
    }
  }
}
