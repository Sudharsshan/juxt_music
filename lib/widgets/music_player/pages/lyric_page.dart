import 'dart:ui';

import 'package:flutter/material.dart';

class LyricPage extends StatefulWidget {
  const LyricPage({super.key, this.isFullScreen = false});

  final bool isFullScreen;

  @override
  State<LyricPage> createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> {
  @override
  Widget build(BuildContext context) {
    final double blurValue = widget.isFullScreen ? 0 : 12;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
        child: Container(
          color: widget.isFullScreen
              ? Colors.transparent
              : Colors.white.withAlpha(25),
          child: const Center(child: Text('Lyric page')),
        ),
      ),
    );
  }
}
