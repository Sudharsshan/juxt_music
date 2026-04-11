import 'package:juxt_music/models/audius_model.dart';

class GenreModel {
  final List<String> genres;

  GenreModel({required this.genres});

  /// Updated Factory: Now accepts the already parsed List of AudiusModels
  /// This prevents decoding the same JSON string multiple times.
  factory GenreModel.fromTrackList(List<AudiusModel> tracks) {
    final List<String> extractedGenres = tracks
        .map((track) => track.genre.trim())
        .where((genre) => genre.isNotEmpty && genre != 'Other')
        .toList();

    return GenreModel(genres: extractedGenres);
  }

  /// NEW: Static filter function to return specific tracks
  static List<AudiusModel> filterByGenre(List<AudiusModel> tracks, String targetGenre) {
    return tracks.where((track) => track.genre == targetGenre).toList();
  }

  /// Returns unique genres sorted alphabetically for easy UI categorization
  List<String> get uniqueSortedGenres {
    final unique = genres.toSet().toList();
    unique.sort();
    return unique;
  }
}

// // Quick Test Execution (Updated for Logic Understanding)
// void main() {
//   // Instead of a raw String, you now pass your List<AudiusModel>
//   // List<AudiusModel> myTracks = ... obtained from your service
//
//   final genreData = GenreModel.fromTrackList(myTracks);
//   
//   print("Unique Genres found: ${genreData.uniqueSortedGenres}");
//
//   // To filter the UI when a user clicks 'Dubstep':
//   // List<AudiusModel> dubstepOnly = GenreModel.filterByGenre(myTracks, 'Dubstep');
// }