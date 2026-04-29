import 'package:flutter/material.dart';
import 'package:juxt_music/states/player_playback_state.dart';

class MusicTrackBar extends StatelessWidget {
  const MusicTrackBar({super.key, required this.playbackState});

  final PlayerPlaybackState playbackState;

  String _formatDuration(double seconds) {
    if (seconds.isNaN || seconds.isInfinite) return "0:00";
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds.remainder(60);
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playbackState,
      builder: (context, child) {
        final currentPosition = playbackState.currentPosition;
        final totalDuration = playbackState.totalDuration;
        
        final highlightColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
        final baseColor = Theme.of(context).textTheme.headlineLarge?.color ?? Colors.white.withAlpha(100);

        final sliderMax = totalDuration > 0 ? totalDuration : 1.0;
        final sliderValue = currentPosition.clamp(0.0, sliderMax);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: highlightColor,
                inactiveTrackColor: baseColor,
                thumbColor: highlightColor,
                trackHeight: 2.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                value: sliderValue,
                max: sliderMax,
                onChanged: (value) {
                  playbackState.updatePosition(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(currentPosition),
                    style: TextStyle(color: highlightColor, fontSize: 12),
                  ),
                  Text(
                    _formatDuration(totalDuration),
                    style: TextStyle(color: baseColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
