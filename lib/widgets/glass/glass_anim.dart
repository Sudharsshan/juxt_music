import 'package:flutter/material.dart';
import 'package:juxt_music/widgets/glass/glass_main.dart';

class GlassAnim extends StatefulWidget {
  const GlassAnim({super.key, required this.child, required this.animationDirection});

  final Widget child;
  final Axis animationDirection;

  @override
  State<GlassAnim> createState() => _GlassAnimState();
}

class _GlassAnimState extends State<GlassAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController expandIt;
  late Animation<double> animateIt;

  final double minStartExtent = 12;

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
  void didUpdateWidget(covariant GlassAnim oldWidget) {
    super.didUpdateWidget(oldWidget);

    final childChanged =
        oldWidget.child.runtimeType != widget.child.runtimeType ||
        oldWidget.child.key != widget.child.key;

    if (childChanged || oldWidget.animationDirection != widget.animationDirection) {
      expandIt
        ..value = 0
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final constraints =
        widget.animationDirection == Axis.horizontal
            ? BoxConstraints(minWidth: minStartExtent)
            : BoxConstraints(minHeight: minStartExtent);

    return GlassMain(
      child: ConstrainedBox(
        constraints: constraints,
        child: SizeTransition(
          sizeFactor: animateIt,
          axisAlignment: 0.0,
          axis: widget.animationDirection,
          child: widget.child,
        ),
      ),
    );
  }
}
