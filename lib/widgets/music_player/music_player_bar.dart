import 'package:flutter/material.dart';

/// Widget returning a player widget with slider controls,
/// timing, button, play control, etc
class MusicPlayerBar extends StatefulWidget {
  const MusicPlayerBar({super.key, required this.streamUrl});

  /// Link URL from where to fetch the audio track
  final String streamUrl;

  @override
  State<MusicPlayerBar> createState() => _MusicPlayerBarState();
}

class _MusicPlayerBarState extends State<MusicPlayerBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
