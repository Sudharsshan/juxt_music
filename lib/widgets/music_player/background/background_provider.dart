import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:juxt_music/states/selected_track_state.dart';
import 'package:juxt_music/widgets/cover_art/cover_box_main.dart';
import 'package:juxt_music/widgets/music_player/background/color_picker_service.dart';

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

  late Color background;

  @override
  void initState() {
    super.initState();

    background = Colors.black.withAlpha(102);
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
    if (kDebugMode) print("Color picking started..");
    final int requestId = ++_paletteRequestId;

    try {
      if (kDebugMode) print("Custom picker started");

      final bytes = await _artworkProvider(widget.trackState);

      if (kDebugMode) print("Img bypes: ${bytes.buffer.lengthInBytes}");
      background = ColorPickerService.getDominantColor(
        bytes.buffer.asUint8List(),
      );

      if (kDebugMode) print("Chosen color: $background");

      if (!mounted || requestId != _paletteRequestId) return;

      setState(() {
        isColorSchemeReady = true;
      });
    } catch (_) {
      if (!mounted || requestId != _paletteRequestId) return;

      if (kDebugMode) print("No color found.");

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

  Future<ByteData> _artworkProvider(SelectedTrackState trackState) async {
    final path = _resolveArtworkPath(trackState);

    if (_isNetworkArtwork(trackState)) {
      final response = await http.get(Uri.parse(path));
      final bytes = response.bodyBytes.buffer.asByteData();
      return bytes;
    }
    return rootBundle.load(path);
  }

  @override
  Widget build(BuildContext context) {
    final artworkPath = _resolveArtworkPath(widget.trackState);
    final isNetworkArtwork = _isNetworkArtwork(widget.trackState);
    final activeColorScheme = imageColorScheme ?? Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
      child: widget.isFullScreen
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
                Flexible(flex: 4, child: Container(color: background)),
              ],
            ),
    );
  }
}
