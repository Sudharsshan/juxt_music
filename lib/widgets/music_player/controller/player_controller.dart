import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({
    super.key,
    required this.buttons,
    this.isCompact = false,
  });

  final Map<FaIconData, VoidCallback> buttons;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final entries = buttons.entries.toList();

    return Padding(
      padding: isCompact ? EdgeInsets.zero : const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
            isCompact ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
        mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          for (final entry in entries)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isCompact ? 2 : 0),
              child: IconButton(
                onPressed: entry.value,
                constraints:
                    isCompact
                        ? const BoxConstraints(minWidth: 34, minHeight: 34)
                        : null,
                padding: isCompact ? EdgeInsets.zero : null,
                visualDensity:
                    isCompact ? VisualDensity.compact : VisualDensity.standard,
                icon: FaIcon(
                  entry.key,
                  size: isCompact ? 15 : 20,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
