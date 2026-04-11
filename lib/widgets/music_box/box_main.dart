import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/track_box_height.dart';

class BoxMain extends StatelessWidget {
  const BoxMain({
    super.key,
    required this.cover,
    required this.title,
    required this.description,
    this.isNetwork = false,
  });

  final String cover;
  final String title, description;
  final bool isNetwork;

  final double width = 170;
  final String placeHolder = "lib/assets/mood_covers/Aggressive.jpg";

  @override
  Widget build(BuildContext context) {
    if(kDebugMode) print("Cover ID: $title path: $cover");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                child: isNetwork
                    ? Image.network(cover, fit: BoxFit.fill)
                    : Image.asset(cover!=""? cover : placeHolder, fit: BoxFit.fill),
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
    );
  }
}
