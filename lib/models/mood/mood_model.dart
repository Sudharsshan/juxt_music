import 'package:juxt_music/models/audius_model.dart';

class MoodModel {
  final List<String> moods;

  MoodModel({required this.moods});

  /// Updated Factory: Now accepts the already parsed List of AudiusModels
  factory MoodModel.fromTrackList(List<AudiusModel> tracks) {
    final List<String> extractedMoods = tracks
        .map(
          (track) => track.mood,
        ) // Pull the 'mood' field from your AudiusModel
        .where((mood) => mood.isNotEmpty) // Filter out empty strings
        .toList();

    return MoodModel(moods: extractedMoods);
  }

  /// Returns unique moods for a cleaner UI list
  List<String> get uniqueMoods => moods.toSet().toList();

  /// Pass the main list and the target mood string (e.g., "Energizing")
  static List<AudiusModel> filterByMood(
    List<AudiusModel> tracks,
    String targetMood,
  ) {
    return tracks.where((track) => track.mood == targetMood).toList();
  }
}

// // Example usage:
// void main() {
//   // String responseBody = await apiCall(); 
//   String responseBody = '''{
//     "data": [
//         {"track_id": 1892405197, "mood": "Energizing"},
//         {"track_id": 804078527, "mood": "Sensual"},
//         {"track_id": 238349420, "mood": "Defiant"}
//     ]
//   }''';

//   final model = MoodModel.fromJson(responseBody);
  
//   print("All Moods: \${model.moods}");
//   print("Unique Moods: \${model.uniqueMoods}");
// }