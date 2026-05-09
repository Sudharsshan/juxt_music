import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/global_var/blur_radius.dart';
import 'package:juxt_music/global_var/music_player_appBar/music_player_icon_map.dart';
import 'package:juxt_music/states/music_que_state.dart';
import 'package:juxt_music/states/player_playback_state.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/music_player/background/background_provider.dart';
import 'package:juxt_music/widgets/music_player/pages/control_page.dart';
import 'package:juxt_music/widgets/music_player/pages/full_screen_page.dart';
import 'package:juxt_music/widgets/music_player/pages/lyric_page.dart';
import 'package:juxt_music/widgets/music_player/pages/mini_player_page.dart';
import 'package:juxt_music/widgets/music_player/pages/queue_page.dart';

enum _PlayerViewMode { mini, defaultPlayer, fullscreen }

/// Main [MusicPlayerMain] widget that swaps between the compact player,
/// the tabbed default player, and the fullscreen player.
class MusicPlayerMain extends StatefulWidget {
  const MusicPlayerMain({super.key, required this.musicQueState});

  final MusicQueState musicQueState;

  @override
  State<MusicPlayerMain> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerMain> {
  static const double _miniPlayerMinWidth = 560;
  static const double _miniPlayerMaxWidth = 1040;
  static const double _miniPlayerHeight = 84;
  static const double _defaultPlayerWidth = 400;
  static const double _playerOuterPadding = 24;

  final ValueNotifier<int> pageNotifier = ValueNotifier<int>(1);
  final PlayerPlaybackState playbackState = PlayerPlaybackState();

  late final PageController _pageController;
  _PlayerViewMode _viewMode = _PlayerViewMode.mini;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: pageNotifier.value);
    pageNotifier.addListener(changePage);

    if (widget.musicQueState.currentTrack != null) {
      playbackState.setTrack(
        widget.musicQueState.currentTrack!,
        onError: (msg) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(CustomSnackBar(message: msg));
          }
        },
      );
    }
    widget.musicQueState.addListener(_onQueueChanged);
  }

  void _onQueueChanged() {
    if (widget.musicQueState.currentTrack != null) {
      playbackState.setTrack(
        widget.musicQueState.currentTrack!,
        onError: (msg) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(CustomSnackBar(message: msg));
          }
        },
      );
    }
  }

  void changePage() {
    if (!_pageController.hasClients) return;

    final targetPage = pageNotifier.value;
    final currentPage = _pageController.page?.round();
    if (currentPage == targetPage) return;

    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void updateNotifier(int value) {
    if (value == pageNotifier.value) return;

    if (kDebugMode) print("Page changed manually to :$value");
    pageNotifier.value = value;
  }

  void _showQueueBoundaryMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(CustomSnackBar(message: message));
  }

  void _nextTrack() {
    final success = widget.musicQueState.nextTrack();
    if (!success) {
      _showQueueBoundaryMessage('No next track in queue');
    }
  }

  void _prevTrack() {
    final success = widget.musicQueState.prevTrack();
    if (!success) {
      _showQueueBoundaryMessage('No previous track in queue');
    }
  }

  void _openMiniPlayer() {
    if (_viewMode == _PlayerViewMode.mini) return;

    setState(() {
      _viewMode = _PlayerViewMode.mini;
    });
  }

  void _openDefaultPlayer({int initialPage = 1}) {
    if (pageNotifier.value != initialPage) {
      pageNotifier.value = initialPage;
    }

    if (_viewMode != _PlayerViewMode.defaultPlayer) {
      setState(() {
        _viewMode = _PlayerViewMode.defaultPlayer;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        changePage();
      }
    });
  }

  void _openFullScreenPlayer() {
    if (_viewMode == _PlayerViewMode.fullscreen) return;

    setState(() {
      _viewMode = _PlayerViewMode.fullscreen;
    });
  }

  double _playerHeightFor(Size screenSize) {
    if (_viewMode == _PlayerViewMode.mini) {
      return _miniPlayerHeight;
    }

    return math.max(0.0, screenSize.height - _playerOuterPadding).toDouble();
  }

  double _miniPlayerWidthFor(Size screenSize) {
    final maxWidth = math.max(0.0, screenSize.width - _playerOuterPadding);
    if (maxWidth <= _miniPlayerMinWidth) {
      return maxWidth;
    }

    final preferredWidth = screenSize.width * 0.84;
    return preferredWidth.clamp(
      _miniPlayerMinWidth,
      math.min(_miniPlayerMaxWidth, maxWidth),
    ).toDouble();
  }

  double _playerWidthFor(Size screenSize) {
    final maxWidth = math.max(0.0, screenSize.width - _playerOuterPadding);

    switch (_viewMode) {
      case _PlayerViewMode.mini:
        return _miniPlayerWidthFor(screenSize);
      case _PlayerViewMode.defaultPlayer:
        return math.min(_defaultPlayerWidth, maxWidth).toDouble();
      case _PlayerViewMode.fullscreen:
        return maxWidth;
    }
  }

  Widget _buildDefaultPlayerPageView() {
    return PageView(
      key: const ValueKey('default-player-page-view'),
      controller: _pageController,
      onPageChanged: updateNotifier,
      children: [
        LyricPage(),
        ControlPage(
          playbackState: playbackState,
          nextTrack: _nextTrack,
          prevTrack: _prevTrack,
          likeTrack: () {},
          isFullScreen: false,
        ),
        QueuePage(musicQueState: widget.musicQueState),
      ],
    );
  }

  Widget _buildDefaultPlayerChrome({
    required Widget child,
    required double width,
    required double height,
  }) {
    final trackState = widget.musicQueState.currentTrack!;

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
                        onPressed: _openMiniPlayer,
                        tooltip: 'Collapse player',
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
                      IconButton(
                        onPressed: _openFullScreenPlayer,
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

  Widget _buildFullScreenPlayer(double width, double height) {
    final trackState = widget.musicQueState.currentTrack!;

    return ClipRRect(
      key: const ValueKey('fullscreen-player'),
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
            BackgroundProvider(trackState: trackState, isFullScreen: true),
            FullscreenPage(
              musicQueState: widget.musicQueState,
              playBackState: playbackState,
              availableWidth: width,
              availableHeight: height,
            ),
            Positioned(
              top: 30,
              right: 30,
              child: IconButton(
                onPressed:
                    () => _openDefaultPlayer(initialPage: pageNotifier.value),
                tooltip: 'Exit fullscreen',
                icon: const Icon(Icons.close_fullscreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.musicQueState.removeListener(_onQueueChanged);
    playbackState.dispose();
    pageNotifier.removeListener(changePage);
    _pageController.dispose();
    pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final playerWidth = _playerWidthFor(screenSize);
    final playerHeight = _playerHeightFor(screenSize);

    final Widget activePlayer;
    switch (_viewMode) {
      case _PlayerViewMode.mini:
        activePlayer = MiniPlayerPage(
          key: const ValueKey('mini-player'),
          playbackState: playbackState,
          availableWidth: playerWidth,
          nextTrack: _nextTrack,
          prevTrack: _prevTrack,
          onOpenPlayer: () => _openDefaultPlayer(initialPage: 1),
          onOpenLyrics: () => _openDefaultPlayer(initialPage: 0),
          onOpenQueue: () => _openDefaultPlayer(initialPage: 2),
          onLikeTrack: () {},
          onMorePressed: () {},
          onCastPressed: () {},
        );
      case _PlayerViewMode.defaultPlayer:
        activePlayer = _buildDefaultPlayerChrome(
          width: playerWidth,
          height: playerHeight,
          child: _buildDefaultPlayerPageView(),
        );
      case _PlayerViewMode.fullscreen:
        activePlayer = _buildFullScreenPlayer(playerWidth, playerHeight);
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 360),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.center,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: child,
            ),
          );
        },
        child: activePlayer,
      ),
    );
  }
}
