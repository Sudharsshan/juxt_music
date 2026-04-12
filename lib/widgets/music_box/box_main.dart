import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/glass_blur_value.dart';
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
    if (kDebugMode) print("Cover ID: $title path: $cover");
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
                child: fillEmptyArea(cover, isNetwork),
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

  Widget fillEmptyArea(String imagePath, bool isNetwork) {
    Widget buildImage(BoxFit fit) {
      return isNetwork
          ? Image.network(
              imagePath,
              fit: fit,
              // Error builder to handle broken links gracefully
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset(placeHolder, fit: fit),
            )
          : Image.asset(
              imagePath.isNotEmpty ? imagePath : placeHolder,
              fit: fit,
            );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. BLURRED BACKDROP (The "Safety Net")
        Positioned.fill(child: buildImage(BoxFit.cover)),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withAlpha(50)),
          ),
        ),

        // 2. MAIN IMAGE (The "Hero")
        // Changing this to cover fixes the "contain" behavior
        Positioned.fill(child: buildImage(BoxFit.cover)),

        // 3. OPTIONAL: Subtle Inner Shadow to give depth
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withAlpha(25),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
