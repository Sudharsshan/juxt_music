import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/artwork_sizesa/size_chart.dart';
import 'package:juxt_music/global_var/description_chart.dart';
import 'package:juxt_music/global_var/links/mood_covers.dart';
import 'package:juxt_music/models/audius_model.dart';
import 'package:juxt_music/models/genre_model.dart';
import 'package:juxt_music/models/mood/mood_model.dart';
import 'package:juxt_music/service/gen_description.dart';
import 'package:juxt_music/widgets/featured_list/featured_main.dart';
import 'package:juxt_music/widgets/music_box/box_main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.trackDetails});

  final List<AudiusModel> trackDetails;

  @override
  Widget build(BuildContext context) {
    final MoodModel moodModel = MoodModel.fromTrackList(trackDetails);
    final GenreModel genreModel = GenreModel.fromTrackList(trackDetails);

    final Map<String, String> moodWithDescription =
        GenDescription.fillDescription(
          moodModel.uniqueSortedMoods,
          DescriptionChart.moodDescriptions,
        );

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
                return BoxMain(
                  cover: MoodCovers.coverArtLinks[entry.key] ?? "",
                  title: entry.key,
                  description: entry.value,
                  onTap:
                      () {}, // TO-DO: Update the on tap to a specific screen with list of tracks matching the mood selected.
                );
              }).toList(),
            ),

            // List of Genre using builder
            ListView.builder(
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
                  featureChildren: [
                    ListView.builder(
                      itemCount: genreFilteredTracks.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, key) {
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: BoxMain(
                            cover: genreFilteredTracks[key].getArtwork(
                              ArtworkSize.small,
                            )!, // track artwork
                            title:
                                genreFilteredTracks[key].title, // track title
                            description: genreFilteredTracks[key]
                                .artist, // For music tracks, i display artists
                            onTap:
                                () {}, // should build a navigation or pop-up to open the track in big mode and play
                            isNetwork: true,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
