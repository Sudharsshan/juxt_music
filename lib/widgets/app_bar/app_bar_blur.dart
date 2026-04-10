import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:juxt_music/global_var/glass_blur_value.dart';

class AppBarBlur extends StatelessWidget {
  const AppBarBlur({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Stack(
        children: [
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: GlassBlurValue.sigmaX,
                sigmaY: GlassBlurValue.sigmaY,
              ),
              child: Container(
                width: MediaQuery.widthOf(context),
                height: 99,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),

          Positioned(top: 15, left: 0, right: 0, child: child),
        ],
      ),
    );
  }
}
