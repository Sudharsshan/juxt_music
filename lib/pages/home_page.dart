import 'package:flutter/material.dart';
import 'package:juxt_music/widgets/music_box/box_main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final cover =
      "https://creatornode2.audius.co/content/baeaaaiqsec2u4tsxabfmc2tzcecd3ewvifjcsfzoxx7ob5pcsmbbznygd6eag/480x480.jpg";
  final title = "Protohype & Chamrae - Ready to Love";
  final description =
      "So excited to present my track \"Ready to Love\" with Charmae! This is a classic melodic dubstep tune that I wanted to bring into the current sound of bass music. Enjoy!\n\n-Protohype & Charmae";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(height: 100),

          Center(
            child: BoxMain(
              cover: cover,
              title: title,
              description: description,
            ),
          ),
        ],
      ),
    );
  }
}
