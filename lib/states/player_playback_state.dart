import 'package:flutter/foundation.dart';
import 'package:juxt_music/states/selected_track_state.dart';

class PlayerPlaybackState extends ChangeNotifier {
  bool isPlaying = false;
  double currentPosition = 0.0;
  double totalDuration = 0.0;
  SelectedTrackState? currentTrack;

  void playPause() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void updatePosition(double position) {
    currentPosition = position;
    notifyListeners();
  }

  void setTrack(SelectedTrackState track) {
    // Only reset position if it's a completely new track.
    // If it's just a hydration update, maintain the current position and playing state.
    if (currentTrack?.preview.id != track.preview.id) {
      currentPosition = 0.0;
      isPlaying = true; // Auto-play new tracks
    }
    
    currentTrack = track;
    totalDuration = track.duration.toDouble();
    notifyListeners();
  }
}
