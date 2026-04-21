import 'package:juxt_music/models/track/track_preview.dart';

class GenreModel {
  final List<String> genres;

  GenreModel({required this.genres});

  factory GenreModel.fromTrackList(List<TrackPreview> tracks) {
    final List<String> extractedGenres = tracks
        .map((track) => track.genre.trim())
        .where((genre) => genre.isNotEmpty && genre != 'Other')
        .toList();

    return GenreModel(genres: extractedGenres);
  }

  /// USE THIS: Removes duplicates and sorts A-Z
  List<String> get uniqueSortedGenres {
    final unique = genres.toSet().toList();
    unique.sort();
    return unique;
  }

  static List<TrackPreview> filterByGenre(
    List<TrackPreview> tracks,
    String targetGenre,
  ) {
    return tracks.where((track) => track.genre == targetGenre).toList();
  }
}

// // Updated Usage Logic:
// void main() {
//   // Use your master list of AudiusModels obtained from your trending service
//   // List<AudiusModel> allTracks = ...
//
//   // 1. Get genres for categorization:
//   // final genreModel = GenreModel.fromTrackList(allTracks);
//   // print("Sorted Genres: ${genreModel.uniqueSortedGenres}");
//
//   // 2. Filter tracks when a user selects a genre:
//   // List<AudiusModel> loFiTracks = GenreModel.filterByGenre(allTracks, "Lo-Fi");
// }
