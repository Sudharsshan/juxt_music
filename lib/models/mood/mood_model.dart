import 'package:juxt_music/models/audius_model.dart';

class MoodModel {
  final List<String> moods;

  MoodModel({required this.moods});

  /// Factory: Extracts mood strings from the already parsed AudiusModel list
  factory MoodModel.fromTrackList(List<AudiusModel> tracks) {
    final List<String> extractedMoods = tracks
        .map((track) => track.mood)
        .where((mood) => mood.isNotEmpty && mood != 'None')
        .toList();

    return MoodModel(moods: extractedMoods);
  }

  /// Unique moods for UI chips/filters
  List<String> get uniqueMoods => moods.toSet().toList();

  /// Static filter to return only tracks matching the selected mood
  static List<AudiusModel> filterByMood(
    List<AudiusModel> tracks,
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