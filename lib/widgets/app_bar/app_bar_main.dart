import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:juxt_music/global_var/blur_radius.dart';

class AppBarMain extends StatefulWidget {
  const AppBarMain({
    super.key,
    required this.pageNotifier,
    required this.children,
    required this.requiredWidth,
  });

  final ValueNotifier pageNotifier;
  final Map<dynamic, dynamic> children;
  final double requiredWidth;

  @override
  State<AppBarMain> createState() => _AppBarMainState();
}

class _AppBarMainState extends State<AppBarMain>
    with SingleTickerProviderStateMixin {
  late int activePage;

  @override
  void initState() {
    super.initState();

    // Initial value for the var
    activePage = widget.pageNotifier.value;

    // Attach a listener to be called when manual page change occurs
    widget.pageNotifier.addListener(updateActivePage);
  }

  /// Function to update the pageNotifier var
  void updateActivePage() {
    setState(() {
      activePage = widget.pageNotifier.value;
    });
  }

  void handlePageChange(int buttonID) {}

  @override
  Widget build(BuildContext context) {
    final iconLength = widget.children.length;

    return IntrinsicWidth(
      child: Stack(
        children: [
          // sliding background
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedAlign(
              curve: Curves.elasticOut,
              alignment: Alignment(
                -1.0 + (activePage * (2.0 / (iconLength - 1))),
                0,
              ),
              duration: const Duration(milliseconds: 800),
              child: Container(
                width: widget.requiredWidth,
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(BlurRadius.radius),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: widget.children.entries.map((entry) {
              bool isActive = activePage == entry.value;
              //print("IconID: ${entry.value} || ActivePage: $activePage");

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                constraints: BoxConstraints(minWidth: 40),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.pageNotifier.value = entry.value;
                      activePage = entry.value;
                      if (kDebugMode) {
                        print("Calling page change to: ${entry.value}");
                      }
                    });
                  },
                  icon: FaIcon(
                    entry.key,
                    size: 20,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withAlpha(100),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
