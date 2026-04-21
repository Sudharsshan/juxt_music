import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/description_chart.dart';
import 'package:juxt_music/global_var/links/mood_covers.dart';
import 'package:juxt_music/models/genre_model.dart';
import 'package:juxt_music/models/mood/mood_model.dart';
import 'package:juxt_music/models/track/track_preview.dart';
import 'package:juxt_music/service/gen_description.dart';
import 'package:juxt_music/states/selected_track_state.dart';
import 'package:juxt_music/widgets/cover_art/cover_box_main.dart';
import 'package:juxt_music/widgets/featured_list/featured_main.dart';
import 'package:juxt_music/widgets/music_box/box_main.dart';

/// Main [HomePage] widget that returns the widgets that fill the landing page
/// of the app.
/// Uses a [SingleChildScrollView] with multiple [ListView.builder]
/// for showing the tracks, genre, etc.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.trackDetails,
    required this.selectedTrack,
  });

  /// A [TrackPreview] list used to render feed rows.
  final List<TrackPreview> trackDetails;

  /// Holds the selected preview and its optional lazy-loaded detail.
  final ValueNotifier<SelectedTrackState?> selectedTrack;

  /// Function updates the [ValueNotifier] variable with the selected track ID
  void updateCurrentTrack(TrackPreview track) {
    selectedTrack.value = SelectedTrackState(
      preview: track,
      isLoadingDetail: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MoodModel moodModel = MoodModel.fromTrackList(trackDetails);
    final GenreModel genreModel = GenreModel.fromTrackList(trackDetails);

    final Map<String, String> moodWithDescription =
        GenDescription.fillDescription(
          moodModel.uniqueSortedMoods,
          DescriptionChart.moodDescriptions,
        );

    if (kDebugMode) {
      print('Mood genre length: ${moodModel.uniqueSortedMoods.length}');
    }

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // SPACING FOR APP BAR HOVER AT START
            const SizedBox(height: 100),

            // MOOD LIST
            FeaturedMain(
              listTitle: "Find Your Mood",
              featureChildren: moodWithDescription.entries.map((entry) {
                if (kDebugMode) print("showing mood: ${entry.key}");
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: BoxMain(
                    cover: MoodCovers.coverArtLinks[entry.key] ?? "",
                    title: entry.key,
                    description: entry.value,
                    onTap:
                        () {}, // TO-DO: Update the on tap to a specific screen with list of tracks matching the mood selected.
                  ),
                );
              }).toList(),
            ),

            // List of Genre using builder
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: genreModel.uniqueSortedGenres.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final List<TrackPreview> genreFilteredTracks =
                    GenreModel.filterByGenre(
                      trackDetails,
                      genreModel.uniqueSortedGenres[index],
                    );

                // List of tracks for each specific genre filtered
                return FeaturedMain(
                  listTitle: genreModel.uniqueSortedGenres[index],
                  listPage: () {},
                  featureChildren: genreFilteredTracks.map((track) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: BoxMain(
                        cover: track.listArtwork ?? CoverBoxMain.placeHolder,
                        title: track.title,
                        description: track.artist.name,
                        onTap: () {
                          updateCurrentTrack(track);
                        },
                        isNetwork: (track.listArtwork ?? '').startsWith('http'),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
