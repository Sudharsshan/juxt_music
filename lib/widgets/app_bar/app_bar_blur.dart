import 'package:flutter/material.dart';
import 'package:gradient_blur/gradient_blur.dart';
import 'package:juxt_music/global_var/glass_blur_value.dart';

class AppBarBlur extends StatelessWidget {
  const AppBarBlur({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 99,
      child: GradientBlur(
        maxBlur: GlassBlurValue.sigmaX + GlassBlurValue.sigmaY / 2,
        minBlur: 0,
        slices: 20, // DEFAULT
        gradient: LinearGradient(
          colors: [
            Theme.of(context).scaffoldBackgroundColor.withAlpha(10),
            Colors.transparent,
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20,),

            child
          ],
        ),
      ),
    );
  }

  // Widget blurGradient(BuildContext context) {
  //   return SizedBox(
  //     height: 99,
  //     width: MediaQuery.sizeOf(context).width,
  //     child: ClipRect(
  //       // Use ClipRect to ensure the blur doesn't bleed out
  //       child: Stack(
  //         children: [
  //           // 1. THE BLUR LAYER (Single layer = No lag, No lines)
  //           Positioned.fill(
  //             child: BackdropFilter(
  //               filter: ImageFilter.blur(
  //                 sigmaX: GlassBlurValue.sigmaX,
  //                 sigmaY: GlassBlurValue.sigmaY,
  //               ),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     begin: Alignment.topCenter,
  //                     end: Alignment.bottomCenter,
  //                     colors: [
  //                       // Start with your theme color (Frosted look)
  //                       Theme.of(
  //                         context,
  //                       ).scaffoldBackgroundColor.withOpacity(0.4),
  //                       // Fade to completely transparent (Clear look)
  //                       Theme.of(
  //                         context,
  //                       ).scaffoldBackgroundColor.withOpacity(0.0),
  //                     ],
  //                     // This creates the "fade" transition
  //                     stops: const [0.0, 1.0],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // /*
  //   Widget blurGradient() {
  //   return ListView.builder(
  //     itemCount: 12,
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemBuilder: (context, value) {
  //       // CALCULATE DECREASING SIGMA VALUES
  //       double currentSigmaX = GlassBlurValue.sigmaX * (1 - (value / 11));
  //       double currentSigmaY = GlassBlurValue.sigmaY * (1 - (value / 11));

  //       return ClipRRect(
  //         child: BackdropFilter(
  //           filter: ImageFilter.blur(
  //             sigmaX: currentSigmaX,
  //             sigmaY: currentSigmaY,
  //           ),
  //           child: Container(
  //             width: MediaQuery.sizeOf(context).width,
  //             height: 110 / 12,
  //             color: Theme.of(context).scaffoldBackgroundColor.withAlpha(40),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  // */
}
