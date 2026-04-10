import 'package:flutter/material.dart';

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
      children: [
        // TITLE
        GestureDetector(
          onTap: () => launchFeaturePage(listPage),
          child: Row(
            children: [
              Text(listTitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 12),
              (listPage != null)
                  ? Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),

        const SizedBox(height: 10),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: featureChildren),
        ),
      ],
    );
  }

  void launchFeaturePage(Function? featuredPage) {
    if (featuredPage != null) {
      featuredPage;
    }
  }
}
