import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:juxt_music/global_var/font_sizes.dart';
import 'package:juxt_music/sub.dart';
import 'package:juxt_music/theme/theme_controller.dart';
import 'package:juxt_music/widgets/glass/glass_main.dart';

void main() {
  // Initialize the media_kit audio backend before any AudioPlayer is created.
  // Required for Linux native audio; Android is enabled for future support.
  JustAudioMediaKit.ensureInitialized(
    linux: true,
    android: true,  // future-proofed; just_audio also works natively on Android
    windows: true,  // harmless; useful if building for Windows desktop too
  );
  runApp(const MainApp());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
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
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: FontSizes.large, color: Colors.black),
        bodyMedium: TextStyle(fontSize: FontSizes.medium, color: Colors.black),
        bodySmall: TextStyle(fontSize: FontSizes.small, color: Colors.grey),
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black.withAlpha(225),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: FontSizes.large, color: Colors.white),
        bodyMedium: TextStyle(fontSize: FontSizes.medium, color: Colors.white),
        bodySmall: TextStyle(fontSize: FontSizes.small, color: Colors.grey),
      ),
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: Scaffold(body: Sub()),
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
