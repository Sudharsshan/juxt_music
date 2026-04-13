import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/glass_blur_value.dart';

class Test extends StatelessWidget {
  const Test({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(10),
        border: Border.all(width: 0),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: GlassBlurValue.sigmaX,
            sigmaY: GlassBlurValue.sigmaY,
          ),
          child: Container(
            color: Colors.grey.withAlpha(60),
            child: Center(child: Text(content)),
          ),
        ),
      ),
    );
  }
}
