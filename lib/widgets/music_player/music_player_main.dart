import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/blur_radius.dart';
import 'package:juxt_music/models/audius_model.dart';

class MusicPlayerMain extends StatefulWidget {
  const MusicPlayerMain({super.key, required this.trackDetails});

  final AudiusModel trackDetails;

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
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: musicPlayerFullScreen ? MediaQuery.sizeOf(context).width : 400,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(40),
        ),
        borderRadius: BorderRadius.circular(BlurRadius.radius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.amber,
            padding: EdgeInsets.all(12),
            child: Text("ID: ${widget.trackDetails.title}"),
          ),
        ],
      ),
    );
  }
}
