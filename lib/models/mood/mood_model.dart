import 'package:juxt_music/models/track/track_preview.dart';

class MoodModel {
  final List<String> moods;

  MoodModel({required this.moods});

  factory MoodModel.fromTrackList(List<TrackPreview> tracks) {
    final List<String> extractedMoods = tracks
        .map((track) => track.mood.trim())
        .where((mood) => mood.isNotEmpty && mood != 'None')
        .toList();

    return MoodModel(moods: extractedMoods);
  }

  /// USE THIS: Removes duplicates and sorts A-Z
  List<String> get uniqueSortedMoods {
    final unique = moods.toSet().toList();
    unique.sort();
    return unique;
  }

  static List<TrackPreview> filterByMood(
    List<TrackPreview> tracks,
    String targetMood,
  ) {
    return tracks.where((track) => track.mood == targetMood).toList();
  }
}

// // Updated Usage Logic:
// void main() {
//   // 1. Fetch data via AudiusTrendingService -> returns List<dynamic>
//   // 2. Map to AudiusModel -> List<AudiusModel> allTracks = rawData.map((m) => AudiusModel.fromJson(m)).toList();
//
//   // 3. Extract moods for the UI:
//   // final moodModel = MoodModel.fromTrackList(allTracks);
//   // print("Unique Moods for UI: ${moodModel.uniqueMoods}");
//
//   // 4. Filter tracks when a user selects a mood:
//   // List<AudiusModel> happyTracks = MoodModel.filterByMood(allTracks, "Energizing");
// }
