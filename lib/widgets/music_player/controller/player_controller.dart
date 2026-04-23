import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({super.key, required this.buttons});

  final Map<FaIconData, VoidCallback> buttons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buttons.entries.map((entry) {
          return IconButton(
            onPressed: entry.value,
            icon: FaIcon(
              entry.key,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}
