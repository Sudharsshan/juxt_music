import 'package:juxt_music/models/track/track_detail.dart';
import 'package:juxt_music/models/track/track_preview.dart';

/// State [SelectedTrackState] holds the active track data that is being displayed

class SelectedTrackState {
  final TrackPreview preview;
  final TrackDetail? detail;
  final bool isLoadingDetail;

  const SelectedTrackState({
    required this.preview,
    this.detail,
    this.isLoadingDetail = false,
  });

  String? get preferredArtwork => detail?.primaryArtwork ?? preview.heroArtwork;
  String get title => detail?.preview.title ?? preview.title;
  String get artistName => detail?.preview.artist.name ?? preview.artist.name;
  int get duration => detail?.preview.duration ?? preview.duration;

  SelectedTrackState copyWith({
    TrackPreview? preview,
    TrackDetail? detail,
    bool? isLoadingDetail,
  }) {
    return SelectedTrackState(
      preview: preview ?? this.preview,
      detail: detail ?? this.detail,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
    );
  }
}
