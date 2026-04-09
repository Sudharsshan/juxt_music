import 'package:flutter/material.dart';
import 'package:juxt_music/widgets/glass/glass_main.dart';

class GlassAnim extends StatefulWidget {
  const GlassAnim({super.key, required this.child});

  final Widget child;

  @override
  State<GlassAnim> createState() => _GlassAnimState();
}

class _GlassAnimState extends State<GlassAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController expandIt;
  late Animation<double> animateIt;

  final double minStartWidth = 12;

  @override
  void initState() {
    super.initState();

    expandIt = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    animateIt = CurvedAnimation(parent: expandIt, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        expandIt.forward();
      }
    });
  }

  @override
  void dispose() {
    expandIt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassMain(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minStartWidth),
        child: SizeTransition(
          sizeFactor: animateIt,
          axisAlignment: 0.0,
          axis: Axis.horizontal,
          child: widget.child,
        ),
      ),
    );
  }
}
