import 'package:flutter/foundation.dart';
import 'package:juxt_music/states/selected_track_state.dart';

/// Class to store the currently playing music tracks and manage the queue.
/// Uses a [List] of [SelectedTrackState] who's data is preserved.
/// Extends [ChangeNotifier] to update UI when queue or track changes.
class MusicQueState extends ChangeNotifier {
  List<SelectedTrackState> currentList = [];
  int currentIndex = -1;

  SelectedTrackState? get currentTrack {
    if (currentIndex >= 0 && currentIndex < currentList.length) {
      return currentList[currentIndex];
    }
    return null;
  }

  void setQueue(List<SelectedTrackState> tracks, {int startIndex = 0}) {
    currentList = List.from(tracks);
    currentIndex = startIndex;
    notifyListeners();
  }

  void addTrack(SelectedTrackState newTrack) {
    currentList.add(newTrack);
    notifyListeners();
  }

  void removeTrack(SelectedTrackState track) {
    try {
      currentList.remove(track);
      if (currentIndex >= currentList.length) {
        currentIndex = currentList.length - 1;
      }
      notifyListeners();
    } catch (_) {
      if (kDebugMode) print("No track found for ID: ${track.title}");
    }
  }

  bool nextTrack() {
    if (currentList.isEmpty) return false;
    if (currentIndex < currentList.length - 1) {
      currentIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool prevTrack() {
    if (currentList.isEmpty) return false;
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

  void playTrackById(String id) {
    final index = currentList.indexWhere((track) => track.preview.id == id);
    if (index != -1) {
      currentIndex = index;
      notifyListeners();
    }
  }

  void updateTrack(SelectedTrackState updatedTrack) {
    final index = currentList.indexWhere((track) => track.preview.id == updatedTrack.preview.id);
    if (index != -1) {
      currentList[index] = updatedTrack;
      notifyListeners();
    }
  }
}
