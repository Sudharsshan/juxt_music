import 'package:flutter/material.dart';
import 'package:gradient_blur/gradient_blur.dart';

class AppBarBlur extends StatelessWidget {
  const AppBarBlur({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const double actualHeight = 99.0, overScanHeight = actualHeight + 11;
    return ClipRRect(
      child: Container(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(25),
        height: actualHeight,
        child: Stack(
          children: [
            Positioned(
              top: -3,
              left: 0,
              right: 0,
              height: overScanHeight,
              child: GradientBlur(
                maxBlur: 12,
                minBlur: 0,
                slices: 20, // MORE BLUURRR
                edgeBlur: null,
                curve: Curves.linear,
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withAlpha(102),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.8],
                ),
                child: const SizedBox.shrink(),
              ),
            ),

            SafeArea(
              child: Center(
                child: Column(children: [const SizedBox(height: 20), child]),
              ),
            ),
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
