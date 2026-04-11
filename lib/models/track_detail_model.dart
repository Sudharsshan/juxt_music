import 'dart:convert';

class TrackDetailModel {
  final int trackId;
  final String artwork;
  final String name;
  final String description;
  final String releaseDate;
  final int favoriteCount;
  final int duration;
  final dynamic userId; // userId is an alphanumeric string in your API

  TrackDetailModel({
    required this.trackId,
    required this.artwork,
    required this.name,
    required this.description,
    required this.releaseDate,
    required this.favoriteCount,
    required this.duration,
    required this.userId,
  });

  /// Factory to search for a specific track ID within the response body
  factory TrackDetailModel.fromId(String source, int targetId) {
    final Map<String, dynamic> jsonResponse = json.decode(source);
    final List<dynamic> tracks = jsonResponse['data'] ?? [];

    // Find the specific track by ID
    final track = tracks.firstWhere(
      (item) => item['track_id'] == targetId,
      orElse: () => throw Exception('Track with ID $targetId not found'),
    );

    return TrackDetailModel(
      trackId: track['track_id'] ?? 0,
      // API provides multiple sizes; pulling the high-res 1000x1000 link
      artwork: track['artwork']?['1000x1000'] ?? '',
      name: track['title'] ?? 'Unknown',
      description: track['description'] ?? '',
      releaseDate: track['release_date'] ?? '',
      favoriteCount: track['favorite_count'] ?? 0,
      duration: track['duration'] ?? 0,
      userId: track['user_id'] ?? '',
    );
  }
}

// // Quick implementation example
// void main() {
//   String responseBody = '''{ "data": [ { 
//     "track_id": 1892405197, 
//     "title": "Ready to Love", 
//     "artwork": {"1000x1000": "https://link.to/art.jpg"},
//     "description": "Electronic track...",
//     "release_date": "2026-04-07T16:41:30Z",
//     "favorite_count": 71,
//     "duration": 197,
//     "user_id": "RK9Mz"
//   } ] }''';

//   try {
//     final track = TrackDetailModel.fromId(responseBody, 1892405197);
//     print('Found Track: ${track.name} by User: ${track.userId}');
//     print('Artwork Link: ${track.artwork}');
//   } catch (e) {
//     print(e);
//   }
// }