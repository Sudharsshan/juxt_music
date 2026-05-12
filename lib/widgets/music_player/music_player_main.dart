import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/music_player_appBar/player_view_mode.dart';
import 'package:juxt_music/states/music_que_state.dart';
import 'package:juxt_music/states/player_playback_state.dart';
import 'package:juxt_music/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:juxt_music/widgets/music_player/pages/default_player_page_view.dart';
import 'package:juxt_music/widgets/music_player/default_player_chrome.dart';
import 'package:juxt_music/widgets/music_player/fullscreen_player.dart';
import 'package:juxt_music/widgets/music_player/animated_player.dart';
import 'package:juxt_music/widgets/music_player/pages/mini_player_page.dart';

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
  static const double _overlayInset = 12;

  final ValueNotifier<int> pageNotifier = ValueNotifier<int>(1);
  final PlayerPlaybackState playbackState = PlayerPlaybackState();

  late final PageController _pageController;
  PlayerViewMode _viewMode = PlayerViewMode.mini;

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
    if (_viewMode == PlayerViewMode.mini) return;

    setState(() {
      _viewMode = PlayerViewMode.mini;
    });
  }

  void _openDefaultPlayer({int initialPage = 1}) {
    if (pageNotifier.value != initialPage) {
      pageNotifier.value = initialPage;
    }

    if (_viewMode != PlayerViewMode.defaultPlayer) {
      setState(() {
        _viewMode = PlayerViewMode.defaultPlayer;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        changePage();
      }
    });
  }

  void _openFullScreenPlayer() {
    if (_viewMode == PlayerViewMode.fullscreen) return;

    setState(() {
      _viewMode = PlayerViewMode.fullscreen;
    });
  }

  double _playerHeightFor(Size screenSize) {
    switch (_viewMode) {
      case PlayerViewMode.mini:
        return _miniPlayerHeight;
      case PlayerViewMode.defaultPlayer:
        return math
            .max(0.0, screenSize.height - (_playerOuterPadding + _overlayInset))
            .toDouble();
      case PlayerViewMode.fullscreen:
        return screenSize.height;
    }
  }

  double _miniPlayerWidthFor(Size screenSize) {
    final maxWidth = math.max(0.0, screenSize.width - _playerOuterPadding);
    if (maxWidth <= _miniPlayerMinWidth) {
      return maxWidth;
    }

    final preferredWidth = screenSize.width * 0.84;
    return preferredWidth
        .clamp(_miniPlayerMinWidth, math.min(_miniPlayerMaxWidth, maxWidth))
        .toDouble();
  }

  double _playerWidthFor(Size screenSize) {
    final maxWidth = math.max(0.0, screenSize.width - _playerOuterPadding);

    switch (_viewMode) {
      case PlayerViewMode.mini:
        return _miniPlayerWidthFor(screenSize);
      case PlayerViewMode.defaultPlayer:
        return math.min(_defaultPlayerWidth, maxWidth).toDouble();
      case PlayerViewMode.fullscreen:
        return screenSize.width;
    }
  }

  Widget _buildDefaultPlayerPageView() {
    return DefaultPlayerPageView(
      pageController: _pageController,
      pageNotifier: pageNotifier,
      playbackState: playbackState,
      musicQueState: widget.musicQueState,
      updateNotifier: updateNotifier,
    );
  }

  Widget _buildDefaultPlayerChrome({
    required Widget child,
    required double width,
    required double height,
  }) {
    return DefaultPlayerChrome(
      width: width,
      height: height,
      musicQueState: widget.musicQueState,
      onOpenMiniPlayer: _openMiniPlayer,
      onOpenFullScreenPlayer: _openFullScreenPlayer,
      pageNotifier: pageNotifier,
      child: child,
    );
  }

  Widget _buildFullScreenPlayer(double width, double height) {
    return FullScreenPlayer(
      width: width,
      height: height,
      musicQueState: widget.musicQueState,
      playbackState: playbackState,
      onExitFullScreen: () =>
          _openDefaultPlayer(initialPage: pageNotifier.value),
    );
  }

  Widget _buildAnimatedPlayer(Widget activePlayer) {
    return AnimatedPlayer(activePlayer: activePlayer);
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
      case PlayerViewMode.mini:
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
      case PlayerViewMode.defaultPlayer:
        activePlayer = _buildDefaultPlayerChrome(
          width: playerWidth,
          height: playerHeight,
          child: _buildDefaultPlayerPageView(),
        );
      case PlayerViewMode.fullscreen:
        activePlayer = _buildFullScreenPlayer(playerWidth, playerHeight);
    }

    switch (_viewMode) {
      case PlayerViewMode.mini:
        return Positioned(
          left: 0,
          right: 0,
          bottom: 15,
          child: Center(child: _buildAnimatedPlayer(activePlayer)),
        );
      case PlayerViewMode.defaultPlayer:
        return Positioned(
          top: _overlayInset,
          right: _overlayInset,
          child: _buildAnimatedPlayer(activePlayer),
        );
      case PlayerViewMode.fullscreen:
        return Positioned.fill(child: _buildAnimatedPlayer(activePlayer));
    }
  }
}
