import 'package:juxt_music/models/artist/artist_preview.dart';

/// [TrackPreview] model stores basic data needed for
/// just displaying music tracks without in dept details.
class TrackPreview {
  final String id;
  final String title;
  final ArtistPreview artist;
  final String genre;
  final String mood;
  final int duration;
  final String? artwork150;
  final String? artwork480;
  final int likes;
  final int plays;
  final int reposts;

  const TrackPreview({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.mood,
    required this.duration,
    required this.artwork150,
    required this.artwork480,
    required this.likes,
    required this.plays,
    required this.reposts,
  });

  String? get listArtwork => artwork150 ?? artwork480;
  String? get heroArtwork => artwork480 ?? artwork150;

  factory TrackPreview.fromJson(Map<String, dynamic> json) {
    final artwork = json['artwork'] as Map<String, dynamic>?;

    return TrackPreview(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      artist: ArtistPreview.fromJson(json['user']),
      genre: json['genre'] ?? 'Other',
      mood: json['mood'] ?? 'None',
      duration: json['duration'] ?? 0,
      artwork150: artwork?['150x150'],
      artwork480: artwork?['480x480'],
      likes: json['favorite_count'] ?? 0,
      plays: json['play_count'] ?? 0,
      reposts: json['repost_count'] ?? 0,
    );
  }
}
