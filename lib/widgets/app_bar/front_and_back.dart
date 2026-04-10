import 'package:flutter/material.dart';
import 'package:juxt_music/widgets/glass/glass_main.dart';

class FrontAndBack extends StatelessWidget {
  const FrontAndBack({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassMain(
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),

          Container(
            height: 8,
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),

          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }
}
