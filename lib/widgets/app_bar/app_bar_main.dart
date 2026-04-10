import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/global_var/blur_radius.dart';
import 'package:juxt_music/widgets/app_bar/icons_map.dart';

class AppBarMain extends StatefulWidget {
  const AppBarMain({
    super.key,
    required this.pageNotifier,
    required this.activePage,
  });

  final ValueNotifier pageNotifier;
  final int activePage;

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
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: IconsMap.barIcons.entries.map((entry) {
        bool isActive = widget.activePage == entry.value;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          constraints: BoxConstraints(minWidth: 60),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).textTheme.bodySmall!.color!.withAlpha(40)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(BlurRadius.radius),
          ),
          child: IconButton(
            onPressed: () {
              widget.pageNotifier.value = entry.value;
            },
            icon: FaIcon(
              entry.key,
              size: 20,
              color: isActive ? Colors.white : Colors.white.withAlpha(100),
            ),
          ),
        );
      }).toList(),
    );
  }
}
