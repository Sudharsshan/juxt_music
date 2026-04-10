import 'package:flutter/material.dart';
import 'package:juxt_music/pages/controller/page_controller_custom.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_main.dart';
import 'package:juxt_music/widgets/app_bar/front_and_back.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';

class Sub extends StatelessWidget {
  Sub({super.key});

  ValueNotifier<int> pageNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          // Page controller custom
          PageControllerCustom(pageNotifier: pageNotifier),

          // App Bar
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: AppBarBlur(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const FrontAndBack(),

                  const SizedBox(width: 20),

                  Center(
                    child: GlassAnim(
                      animationDirection: Axis.horizontal,
                      child: AppBarMain(
                        pageNotifier: pageNotifier,
                        activePage: pageNotifier.value,
                      ),
                    ),
                  ),

                  const Visibility(visible: false, child: FrontAndBack()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
