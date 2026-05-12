import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/blur_radius.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/music_player/background/background_provider.dart';
import 'package:juxt_music/global_var/music_player_appBar/music_player_icon_map.dart';
import 'package:juxt_music/states/music_que_state.dart';

class DefaultPlayerChrome extends StatelessWidget {
  const DefaultPlayerChrome({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.musicQueState,
    required this.onOpenMiniPlayer,
    required this.onOpenFullScreenPlayer,
    required this.pageNotifier,
  });

  final Widget child;
  final double width;
  final double height;
  final MusicQueState musicQueState;
  final VoidCallback onOpenMiniPlayer;
  final VoidCallback onOpenFullScreenPlayer;
  final ValueNotifier<int> pageNotifier;

  @override
  Widget build(BuildContext context) {
    final trackState = musicQueState.currentTrack!;

    return ClipRRect(
      key: const ValueKey('default-player'),
      borderRadius: BorderRadius.circular(BlurRadius.radius),
      child: Container(
        width: width,
        height: height,
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
            BackgroundProvider(trackState: trackState, isFullScreen: false),
            child,
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
                        onPressed: onOpenMiniPlayer,
                        tooltip: 'Collapse player',
                        icon: const Icon(Icons.expand_more),
                      ),
                      const SizedBox(width: 15),
                      GlassAnim(
                        animationDirection: Axis.horizontal,
                        child: ValueListenableBuilder<int>(
                          valueListenable: pageNotifier,
                          builder: (context, page, _) {
                            return AppBarMain(
                              pageNotifier: pageNotifier,
                              children: MusicPlayerIconMap.musicPlayerIcons,
                              requiredWidth: 50,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: onOpenFullScreenPlayer,
                        tooltip: 'Open fullscreen player',
                        icon: const Icon(Icons.open_in_full),
                      ),
                      const SizedBox(width: 5),
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