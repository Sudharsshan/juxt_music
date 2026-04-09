import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMain extends StatelessWidget {
  const GlassMain({super.key, required this.child});

  final Widget child;

  final double x = 20, y = 20; // blur concentration
  final double radius = 37;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.white, width: 1.25),
          vertical: BorderSide(color: Colors.white, width: 0.2),
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      constraints: BoxConstraints(minWidth: 12, minHeight: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: x, sigmaY: y),
          child: Container(
            padding: EdgeInsets.all(2),
            color: Colors.white.withAlpha(40),
            child: child
          ),
        ),
      ),
    );
  }
}
