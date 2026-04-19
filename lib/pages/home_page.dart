import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/artwork_sizes/artwork_sizes.dart';
import 'package:juxt_music/global_var/description_chart.dart';
import 'package:juxt_music/global_var/links/mood_covers.dart';
import 'package:juxt_music/models/audius_model.dart';
import 'package:juxt_music/models/genre_model.dart';
import 'package:juxt_music/models/mood/mood_model.dart';
import 'package:juxt_music/service/gen_description.dart';
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

  /// An [AudiusModel] variable to hold the track details to show
  final List<AudiusModel> trackDetails;

  /// A [AudiusModel] variable to hold the currently selected track to play
  final ValueNotifier<AudiusModel?> selectedTrack;

  /// Function updates the [ValueNotifier] variable with the selected track ID
  void updateCurrentTrack(AudiusModel track) {
    selectedTrack.value = track;
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

    if (kDebugMode)
      print('Mood genre length: ${moodModel.uniqueSortedMoods.length}');

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
                final List<AudiusModel> genreFilteredTracks =
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
                        cover: track.getArtwork(ArtworkSize.small)!,
                        title: track.title,
                        description: track.artist,
                        onTap: () {
                          updateCurrentTrack(track);
                        },
                        isNetwork: true,
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
