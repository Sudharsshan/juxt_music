import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/links/mood_covers.dart';

class CoverBoxMain extends StatelessWidget {
  const CoverBoxMain({
    super.key,
    required this.imagePath,
    required this.isNetwork,
  });

  final String imagePath;
  final bool isNetwork;

  static final placeHolder = MoodCovers.coverArtLinks['Mood']!;

  @override
  Widget build(BuildContext context) {
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
              border: Border.all(color: Colors.white.withAlpha(25), width: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImage(BoxFit fit) {
    if (!isNetwork) {
      return Image.asset(
        imagePath.isNotEmpty ? imagePath : placeHolder,
        fit: fit,
      );
    }

    return CachedNetworkImage(
      imageUrl: imagePath,
      fit: fit,
      // This is the app-wide cache manager.
      // It automatically remembers this image across different screens.
      placeholder: (context, url) => Container(
        color: Colors.grey[900],
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Image.asset(placeHolder, fit: fit),
      // Optimization: Tell the cache to resize the image in memory
      // so a 1080p image doesn't lag a 170x170 list item.
      memCacheHeight: 400,
      memCacheWidth: 400,
    );
  }
}
