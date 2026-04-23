import 'package:flutter/material.dart';
import 'package:juxt_music/states/selected_track_state.dart';
import 'package:juxt_music/widgets/cover_art/cover_box_main.dart';

/// Provides the background shown on the music player widget.
class BackgroundProvider extends StatefulWidget {
  const BackgroundProvider({
    super.key,
    required this.trackState,
    required this.isFullScreen,
  });

  final SelectedTrackState trackState;
  final bool isFullScreen;

  @override
  State<BackgroundProvider> createState() => _BackgroundProviderState();
}

class _BackgroundProviderState extends State<BackgroundProvider> {
  // Hold the color scheme for the backgound image and paiting
  ColorScheme? imageColorScheme;
  bool isColorSchemeReady = false;

  String? _lastPaletteKey;
  int _paletteRequestId = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final paletteKey = _paletteKeyFor(widget.trackState);
    if (_lastPaletteKey != paletteKey) {
      _lastPaletteKey = paletteKey;
      updateColorScheme();
    }
  }

  @override
  void didUpdateWidget(covariant BackgroundProvider oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldKey = _paletteKeyFor(oldWidget.trackState);
    final newKey = _paletteKeyFor(widget.trackState);

    if (oldKey != newKey) {
      _lastPaletteKey = newKey;
      setState(() {
        imageColorScheme = null;
        isColorSchemeReady = false;
      });
      updateColorScheme();
    }
  }

  Future<void> updateColorScheme() async {
    final int requestId = ++_paletteRequestId;
    final brightness = MediaQuery.platformBrightnessOf(context);
    final ImageProvider provider = _artworkProvider(widget.trackState);

    try {
      final ColorScheme newScheme = await ColorScheme.fromImageProvider(
        provider: provider,
        brightness: brightness,
      );

      if (!mounted || requestId != _paletteRequestId) return;

      setState(() {
        imageColorScheme = newScheme;
        isColorSchemeReady = true;
      });
    } catch (_) {
      if (!mounted || requestId != _paletteRequestId) return;

      setState(() {
        imageColorScheme = Theme.of(context).colorScheme;
        isColorSchemeReady = true;
      });
    }
  }

  String _paletteKeyFor(SelectedTrackState trackState) {
    return '${trackState.preview.id}|${_resolveArtworkPath(trackState)}|${MediaQuery.platformBrightnessOf(context).name}|${trackState.detail != null}';
  }

  String _resolveArtworkPath(SelectedTrackState trackState) {
    return trackState.preferredArtwork ?? CoverBoxMain.placeHolder;
  }

  bool _isNetworkArtwork(SelectedTrackState trackState) {
    return _resolveArtworkPath(trackState).startsWith('http');
  }

  ImageProvider _artworkProvider(SelectedTrackState trackState) {
    final path = _resolveArtworkPath(trackState);
    if (_isNetworkArtwork(trackState)) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final artworkPath = _resolveArtworkPath(widget.trackState);
    final isNetworkArtwork = _isNetworkArtwork(widget.trackState);
    final activeColorScheme = imageColorScheme ?? Theme.of(context).colorScheme;

    return widget.isFullScreen
        ? Row(
            children: [
              Flexible(
                flex: 1,
                child: CoverBoxMain(
                  imagePath: artworkPath,
                  isNetwork: isNetworkArtwork,
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(color: activeColorScheme.primary),
              ),
            ],
          )
        : Column(
            children: [
              Flexible(
                flex: 5,
                child: CoverBoxMain(
                  imagePath: artworkPath,
                  isNetwork: isNetworkArtwork,
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(color: activeColorScheme.primary),
              ),
            ],
          );
  }
}
