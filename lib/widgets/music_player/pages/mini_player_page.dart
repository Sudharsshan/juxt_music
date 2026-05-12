import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/states/player_playback_state.dart';
import 'package:juxt_music/widgets/cover_art/cover_box_main.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/music_player/controller/player_controller.dart';
import 'package:juxt_music/widgets/music_track_bar/music_track_bar.dart';

class MiniPlayerPage extends StatelessWidget {
  const MiniPlayerPage({
    super.key,
    required this.playbackState,
    required this.availableWidth,
    required this.nextTrack,
    required this.prevTrack,
    required this.onOpenPlayer,
    required this.onOpenLyrics,
    required this.onOpenQueue,
    required this.onLikeTrack,
    required this.onMorePressed,
    required this.onCastPressed,
  });

  final PlayerPlaybackState playbackState;
  final double availableWidth;
  final VoidCallback nextTrack;
  final VoidCallback prevTrack;
  final VoidCallback onOpenPlayer;
  final VoidCallback onOpenLyrics;
  final VoidCallback onOpenQueue;
  final VoidCallback onLikeTrack;
  final VoidCallback onMorePressed;
  final VoidCallback onCastPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 80,
        maxWidth: availableWidth,
      ),
      child: ListenableBuilder(
        listenable: playbackState,
        builder: (context, child) {
          final track = playbackState.currentTrack;
          final title = track?.title ?? '';
          final artist = track?.artistName ?? '';
          final artwork = track?.preferredArtwork ?? '';
          final isPlaying = playbackState.isPlaying;
          final isMuted = playbackState.isMuted;
          final isTightLayout = availableWidth < 760;

          final infoSection = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onOpenPlayer,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title.isEmpty ? 'Unknown Track' : title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: artist.isEmpty ? '' : '  -  $artist',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.titleMedium?.color?.withAlpha(190),
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                MusicTrackBar(
                  playbackState: playbackState,
                  layout: MusicTrackBarLayout.inline,
                ),
              ],
            ),
          );

          final controlButtons = PlayerController(
            isCompact: true,
            buttons: {
              FontAwesomeIcons.shuffle: () {},
              FontAwesomeIcons.backward: prevTrack,
              (isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play):
                  playbackState.playPause,
              FontAwesomeIcons.forward: nextTrack,
              FontAwesomeIcons.repeat: () {},
            },
          );

          final groupedActions = [
            _MiniActionButton(
              tooltip: 'More options',
              icon: Icons.more_horiz_rounded,
              onPressed: onMorePressed,
            ),
            _MiniActionButton(
              tooltip: 'Favorite',
              icon: Icons.star_outline_rounded,
              onPressed: onLikeTrack,
            ),
            const SizedBox(width: 20, height: 20),
            _MiniActionButton(
              tooltip: 'Cast',
              icon: Icons.cast_rounded,
              onPressed: onCastPressed,
            ),
            _MiniActionButton(
              tooltip: isMuted ? 'Unmute' : 'Mute',
              icon: isMuted
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              onPressed: () {
                playbackState.toggleMute();
              },
            ),
            const SizedBox(width: 20, height: 20),
            _MiniActionButton(
              tooltip: 'Open lyrics',
              icon: Icons.lyrics_outlined,
              onPressed: onOpenLyrics,
            ),
            _MiniActionButton(
              tooltip: 'Open queue',
              icon: Icons.menu_rounded,
              onPressed: onOpenQueue,
            ),
          ];

          if (isTightLayout) {
            return GlassAnim(
              animationDirection: Axis.horizontal,
              child: SizedBox(
                width: availableWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _buildArtwork(onOpenPlayer, artwork),
                          const SizedBox(width: 12),
                          Expanded(child: infoSection),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: controlButtons),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 8,
                              runSpacing: 8,
                              children: groupedActions,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return GlassAnim(
            animationDirection: Axis.horizontal,
            child: SizedBox(
              width: availableWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    _buildArtwork(onOpenPlayer, artwork),
                    const SizedBox(width: 14),
                    Expanded(child: infoSection),
                    const SizedBox(width: 14),
                    controlButtons,
                    const SizedBox(width: 20),
                    ...groupedActions,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtwork(VoidCallback onPressed, String artwork) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 52,
          height: 52,
          child: CoverBoxMain(
            imagePath: artwork,
            isNetwork: artwork.startsWith('http'),
          ),
        ),
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  const _MiniActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        icon: Icon(
          icon,
          size: 20,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}
