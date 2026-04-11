import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/track_box_height.dart';

class FeaturedMain extends StatelessWidget {
  const FeaturedMain({
    super.key,
    required this.listTitle,
    required this.featureChildren,
    this.listPage,
  });

  final String listTitle;
  final List<Widget> featureChildren;
  final Function? listPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align title to the left
      children: [
        // TITLE SECTION
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ), // Match card spacing
          child: GestureDetector(
            onTap: () => launchFeaturePage(listPage),
            child: Row(
              children: [
                Text(listTitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 12),
                if (listPage != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16, // Keep it proportional
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // THE SCROLLABLE LIST
        SizedBox(
          height: TrackBoxHeight.height,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ), // Better start/end padding
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(), // Feels more "Apple-like"
            children: featureChildren,
          ),
        ),
      ],
    );
  }

  void launchFeaturePage(Function? featuredPage) {
    if (featuredPage != null) {
      featuredPage();
    }
  }
}
