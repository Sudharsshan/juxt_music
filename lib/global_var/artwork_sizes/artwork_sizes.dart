enum ArtworkSize {
  small(150, '150x150'),
  medium(480, '480x480'),
  large(1000, '1000x1000'); // Audius uses 1000x1000 for high-res

  /// The pixel dimension (e.g., 150)
  final int dimension;

  /// The key used in the Audius JSON map
  final String key;

  const ArtworkSize(this.dimension, this.key);
}