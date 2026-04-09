import 'package:flutter/material.dart';

class ThemeController {
  // Keeping dark mode as default for this app
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.dark,
  );
}
