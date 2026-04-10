import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/widgets/app_bar/icons_map.dart';

class AppBarMain extends StatefulWidget {
  const AppBarMain({super.key, required this.pageNotifier});

  final ValueNotifier pageNotifier;

  @override
  State<AppBarMain> createState() => _AppBarMainState();
}

class _AppBarMainState extends State<AppBarMain>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handlePageChange(int buttonID) {}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: IconsMap.barIcons.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: IconButton(
            onPressed: () {
              widget.pageNotifier.value = entry.value;
            },
            icon: FaIcon(entry.key, size: 20,),
          ),
        );
      }).toList(),
    );
  }
}
