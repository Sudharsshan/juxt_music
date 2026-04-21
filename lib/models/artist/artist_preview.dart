/// Model [ArtistPreview] stores only artist id and name that is
/// used in [TrackPreview] model just to display basic details
/// where-ever needed
class ArtistPreview {
  final String id;
  final String name;

  const ArtistPreview({required this.id, required this.name});

  factory ArtistPreview.fromJson(Map<String, dynamic>? json) {
    return ArtistPreview(
      id: json?['id'] ?? '',
      name: json?['name'] ?? 'Unknown Artist',
    );
  }
}
