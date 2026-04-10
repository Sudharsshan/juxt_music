import 'package:flutter/material.dart';

class BoxMain extends StatelessWidget {
  const BoxMain({
    super.key,
    required this.cover,
    required this.title,
    required this.description,
  });

  final String cover;
  final String title, description;

  final double width = 170, height = 255;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          // COVER
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 170,
              width: 170,
              child: Image.network(cover, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(height: 3,),

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
    );
  }
}
