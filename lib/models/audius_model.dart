import 'package:juxt_music/global_var/artwork_sizesa/size_chart.dart';

class AudiusModel {
  final String id;
  final int trackId; // Integer ID for internal sorting/logic
  final String title;
  final String artist;
  final String genre;
  final String mood;
  final int duration;

  // POPULARITY & SORTING FIELDS
  final int likes;
  final int plays;
  final int reposts; // Crucial for "Trending" logic
  final String uploadDate;

  // ARTWORK HANDLING
  final Map<String, dynamic>? _artworkSizes;

  AudiusModel({
    required this.id,
    required this.trackId,
    required this.title,
    required this.artist,
    required this.genre,
    required this.mood,
    required this.duration,
    required this.likes,
    required this.plays,
    required this.reposts,
    required this.uploadDate,
    Map<String, dynamic>? artworkSizes,
  }) : _artworkSizes = artworkSizes;

  factory AudiusModel.fromJson(Map<String, dynamic> json) {
    // Date Parsing
    String rawDate = json['updated_at'] ?? json['release_date'] ?? "";
    String formattedDate = rawDate.isNotEmpty
        ? DateTime.parse(rawDate).toIso8601String().split('T')[0]
        : "Unknown Date";

    return AudiusModel(
      id: json['id'] ?? '',
      trackId: json['track_id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      artist: json['user']?['name'] ?? 'Unknown Artist',
      // NEW SORTING FIELDS
      genre: json['genre'] ?? 'Other',
      mood: json['mood'] ?? 'None',
      reposts: json['repost_count'] ?? 0,

      duration: json['duration'] ?? 0,
      likes: json['favorite_count'] ?? 0,
      plays: json['play_count'] ?? 0,
      uploadDate: formattedDate,
      artworkSizes: json['artwork'],
    );
  }

  // Updated code to use Enum for type safe
  String? getArtwork(ArtworkSize size) {
    if (_artworkSizes == null) return null;
    return _artworkSizes[size.key];
  }
}

/*
// Quick implementation example
void main() {
  String responseBody = '''{ "data": [ { 
    "track_id": 1892405197, 
    "title": "Ready to Love", 
    "artwork": {"1000x1000": "https://link.to/art.jpg"},
    "description": "Electronic track...",
    "release_date": "2026-04-07T16:41:30Z",
    "favorite_count": 71,
    "duration": 197,
    "user_id": "RK9Mz"
  } ] }''';

  try {
    final track = AudiusModel.fromId(responseBody, 1892405197);
    print('Found Track: ${track.name} by User: ${track.userId}');
    print('Artwork Link: ${track.artwork}');
  } catch (e) {
    print(e);
  }
}
*/
