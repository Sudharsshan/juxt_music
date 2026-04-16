import 'package:flutter/material.dart';
import 'package:juxt_music/models/audius_model.dart';

class MusicPlayerMain extends StatefulWidget {
  const MusicPlayerMain({super.key, required this.trackDetails});

  final List<AudiusModel> trackDetails;

  @override
  State<MusicPlayerMain> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayerMain> {
  /// button to check if music player is full screen or not
  bool musicPlayerFullScreen = false; // by default in mini-player mode

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          width: musicPlayerFullScreen ? MediaQuery.sizeOf(context).width : 400,
        ),
      ],
    );
  }
}
