import 'package:juxt_music/models/track/track_preview.dart';

/// Model [TrackDetail] holds the complete data for any track selected
/// along with stream urls
class TrackDetail {
  final TrackPreview preview;
  final String description;
  final DateTime? releaseDate;
  final String? artwork1000;
  final List<String> streamUrls;
  final bool isStreamable;

  const TrackDetail({
    required this.preview,
    required this.description,
    required this.releaseDate,
    required this.artwork1000,
    required this.streamUrls,
    required this.isStreamable,
  });

  String? get primaryArtwork => artwork1000 ?? preview.heroArtwork;

  factory TrackDetail.fromJson(
    Map<String, dynamic> json, {
    required List<String> streamUrls,
  }) {
    final artwork = json['artwork'] as Map<String, dynamic>?;

    return TrackDetail(
      preview: TrackPreview.fromJson(json),
      description: json['description'] ?? '',
      releaseDate: json['release_date'] != null
          ? DateTime.tryParse(json['release_date'])
          : null,
      artwork1000: artwork?['1000x1000'],
      streamUrls: streamUrls,
      isStreamable: json['is_streamable'] ?? true,
    );
  }
}
