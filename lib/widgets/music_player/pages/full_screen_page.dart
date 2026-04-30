import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/blur_radius.dart';
import 'package:juxt_music/global_var/music_player_appBar/music_player_full_screen_icon_map.dart';
import 'package:juxt_music/states/music_que_state.dart';
import 'package:juxt_music/states/player_playback_state.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/cover_art/cover_box_main.dart';
import 'package:juxt_music/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/music_player/pages/control_page.dart';
import 'package:juxt_music/widgets/music_player/pages/lyric_page.dart';
import 'package:juxt_music/widgets/music_player/pages/queue_page.dart';

class FullscreenPage extends StatefulWidget {
  const FullscreenPage({
    super.key,
    required this.musicQueState,
    required this.playBackState,
  });

  final MusicQueState musicQueState;
  final PlayerPlaybackState playBackState;

  @override
  State<FullscreenPage> createState() => _FullscreenPageState();
}

class _FullscreenPageState extends State<FullscreenPage> {
  ValueNotifier<int> pageNotifier = ValueNotifier<int>(0);
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: pageNotifier.value);

    pageNotifier.addListener(changePage);
  }

  void changePage() {
    setState(() {
      pageController.animateToPage(
        pageNotifier.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void updateNotifier(int value) {
    if (value == pageNotifier.value) return;

    if (kDebugMode) print("Page manual change (fullscreen) to: $value");
    setState(() {
      pageNotifier.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final requiredWidth = screenSize.width * 0.8;
    final requiredHeight = screenSize.height * 0.7;

    return ClipRRect(
      borderRadius: BorderRadius.circular(BlurRadius.radius + 2),
      child: Container(
        // TO-DO: REMOVE THIS ONCE THE FULL SCREEN WIDGET FOR PLAYER IS FINALIZED
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withAlpha(102), width: 1.2),
          borderRadius: BorderRadius.circular(BlurRadius.radius),
        ),
        child: SizedBox(
          width: requiredWidth,
          height: requiredHeight,
          child: Row(
            children: [
              SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 22),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(BlurRadius.radius),
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: CoverBoxMain(
                          imagePath:
                              widget
                                  .musicQueState
                                  .currentTrack
                                  ?.preferredArtwork ??
                              "",
                          isNetwork: true,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ControlPage(
                          playbackState: widget.playBackState,
                          nextTrack: () {
                            final success = widget.musicQueState.nextTrack();
                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                  message: 'No next track in queue',
                                ),
                              );
                            }
                          },
                          prevTrack: () {
                            final success = widget.musicQueState.prevTrack();
                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(
                                  message: 'No previous track in queue',
                                ),
                              );
                            }
                          },
                          likeTrack: () {},
                          isFullScreen: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GlassAnim(
                      animationDirection: Axis.horizontal,
                      child: AppBarMain(
                        pageNotifier: pageNotifier,
                        children:
                            MusicPlayerFullScreenIconMap.fullScreenIconMap,
                        requiredWidth: 50,
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        onPageChanged: (value) => updateNotifier(value),
                        children: [
                          LyricPage(
                            isFullScreen:
                                true, // This widget is build since the main widget is already full screen
                          ),

                          QueuePage(
                            musicQueState: widget.musicQueState,
                            isFullScreen: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
