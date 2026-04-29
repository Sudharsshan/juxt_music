import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/models/track/track_detail.dart';
import 'package:juxt_music/models/track/track_preview.dart';
import 'package:juxt_music/pages/controller/page_controller_custom.dart';
import 'package:juxt_music/service/mirror_provider.dart';
import 'package:juxt_music/service/trending_service.dart';
import 'package:juxt_music/states/music_que_state.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/app_bar/front_and_back.dart';
import 'package:juxt_music/widgets/app_bar/icons_map.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/music_player/music_player_main.dart';

/// The sub main class which is an extension of [main.dart] class
/// this holds the main widget functionality of maintaining
/// * - [Notifiers] such as scroll, page, offset
/// - Also holds key functions for fetching & populating main fields
class Sub extends StatefulWidget {
  const Sub({super.key});

  @override
  State<Sub> createState() => _SubState();
}

class _SubState extends State<Sub> {
  final ValueNotifier<int> pageNotifier = ValueNotifier(0);
  final ValueNotifier<int> offsetNotifier = ValueNotifier(0);
  final TrendingService _trendingService = TrendingService();
  final MirrorProvider _mirrorProvider = MirrorProvider();
  final Map<String, TrackDetail> _detailCache = {};

  final int limit = 50;
  List<TrackPreview> trackDetails = [];
  bool isDetailsReady = false;

  /// selected track to play
  final MusicQueState musicQueState = MusicQueState();

  @override
  void initState() {
    super.initState();

    musicQueState.addListener(_hydrateSelectedTrack);
    updateTrends();
  }

  /// This [updateTrends] function fetches the list of tracks, their entire details
  /// from the [Audius] server and populates them using the function [parseJSON]
  /// Once the details are ready, it sets the bool [isDetailsReady] as TRUE
  /// So that all the children widgets are notified as data is ready and
  /// can utilize the available data to build their required widgets.
  Future<void> updateTrends() async {
    final fetchedTracks = await _trendingService.fetchTrendingTracks(
      limit: limit,
      offset: offsetNotifier.value,
    );
    if (kDebugMode) print("Response Ready. \n${fetchedTracks.length}");

    if (!mounted) return;

    setState(() {
      trackDetails = fetchedTracks;
      isDetailsReady = true;
    });
  }

  /// Hydrates the selected preview with richer detail only when a user opens a
  /// track. This keeps the feed cheap while letting the player upgrade itself
  /// after selection.
  Future<void> _hydrateSelectedTrack() async {
    final selected = musicQueState.currentTrack;
    if (selected == null || !selected.isLoadingDetail || selected.detail != null) {
      return;
    }

    final cachedDetail = _detailCache[selected.preview.id];
    if (cachedDetail != null) {
      musicQueState.updateTrack(selected.copyWith(
        detail: cachedDetail,
        isLoadingDetail: false,
      ));
      return;
    }

    final String requestedTrackId = selected.preview.id;
    final TrackDetail? detail = await _trendingService.fetchTrackDetail(
      trackId: requestedTrackId,
      mirrorProvider: _mirrorProvider,
    );

    if (!mounted) return;

    final latestSelected = musicQueState.currentTrack;
    if (latestSelected == null || latestSelected.preview.id != requestedTrackId) {
      return;
    }

    if (detail == null) {
      musicQueState.updateTrack(latestSelected.copyWith(isLoadingDetail: false));
      return;
    }

    _detailCache[requestedTrackId] = detail;
    musicQueState.updateTrack(latestSelected.copyWith(
      detail: detail,
      isLoadingDetail: false,
    ));
  }

  @override
  void dispose() {
    musicQueState.removeListener(_hydrateSelectedTrack);
    pageNotifier.dispose();
    offsetNotifier.dispose();
    musicQueState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        // Page controller custom
        PageControllerCustom(
          pageNotifier: pageNotifier,
          trackDetails: trackDetails,
          isDataReady: isDetailsReady,
          musicQueState: musicQueState,
        ),
        // App Bar
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: AppBarBlur(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),

                  const FrontAndBack(),

                  const SizedBox(width: 15),

                  GlassAnim(
                    animationDirection: Axis.horizontal,
                    child: AppBarMain(
                      pageNotifier: pageNotifier,
                      children: IconsMap.barIcons,
                      requiredWidth: 50, // good value for just icons
                    ),
                  ),

                  const SizedBox(width: 20),

                  const Opacity(
                    opacity: 0,
                    child: IgnorePointer(child: FrontAndBack()),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Music Player widget
        Positioned(
          top: 0,
          right: 0,
          child: ListenableBuilder(
            listenable: musicQueState,
            builder: (context, child) {
              final track = musicQueState.currentTrack;
              if (track == null) return SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: MusicPlayerMain(musicQueState: musicQueState),
              );
            },
          ),
        ),
      ],
    );
  }
}
