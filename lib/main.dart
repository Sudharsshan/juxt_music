import 'package:flutter/material.dart';
import 'package:juxt_music/theme/theme_controller.dart';
import 'package:juxt_music/widgets/app_bar/app_bar_blur.dart';
import 'package:juxt_music/widgets/glass/glass_anim.dart';
import 'package:juxt_music/widgets/glass/glass_main.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: Scaffold(
            body: Center(
              child: Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          color: Colors.amber,
                        ),
                      ),
                      Expanded(child: Container(color: Colors.red)),
                      Expanded(
                        child: Container(color: Colors.deepPurpleAccent),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GlassMain(child: Text("Hello Juxt!")),

                      const SizedBox(height: 15),

                      const GlassAnim(
                        child: Text(
                          "This is animation. YO! Come and check this out!!",
                        ),
                      ),

                      const SizedBox(height: 15),

                      test(context),
                    ],
                  ),

                  // App Bar
                  const Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: AppBarBlur(
                      child: Center(
                        child: GlassAnim(
                          child: Text(
                            "This is animation. YO! Come and check this out!!",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget test(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Colors.transparent],
        stops: [0.45, 1.0],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: GlassMain(
        child: Text("Test widget", style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
