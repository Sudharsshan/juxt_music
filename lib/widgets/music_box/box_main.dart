import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/track_box_height.dart';
import 'package:juxt_music/widgets/cover_art/cover_box_main.dart';

/// Creates the main track boxes displayed on the home screen and throughout the UI.
///
/// This is a sub-widget typically used within a horizontal scrollable row
/// to showcase featured tracks, albums, or artists.
class BoxMain extends StatelessWidget {
  const BoxMain({
    super.key,
    required this.cover,
    required this.title,
    required this.description,
    this.isNetwork = false,
    required this.onTap,
  });

  /// Construct a [BoxMain] widget.
  ///
  /// * [cover]: The image path (Network URL or Asset path).
  /// * [title]: The primary name of the track or album.
  /// * [description]: Secondary text, usually the artist name or genre.
  /// * [isNetwork]: Set to `true` if [cover] is a URL.
  /// * [onTap]: Callback function triggered when the box is pressed.

  final String cover;
  final String title, description;
  final bool isNetwork;
  final Function onTap;

  final double width = 170;

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) print("Cover ID: $title path: $cover");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => onTap(),
        child: SizedBox(
          width: width,
          height: TrackBoxHeight.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COVER
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 170,
                  width: 170,
                  child: CoverBoxMain(imagePath: cover, isNetwork: isNetwork),
                ),
              ),

              const SizedBox(height: 3),

              // TITLE
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // DESCRIPTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
