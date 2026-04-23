import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

/// Class returns the background color from the provided [ByteData] of the image
class ColorPickerService {
  static Color getDominantColor(Uint8List bytes) {
    final image = img.decodeImage(bytes);
    if (image == null) return Colors.grey;

    // Resize to reduce noise + speed
    final resized = img.copyResize(image, width: 50);

    final Map<int, int> colorFrequency = {};

    for (int y = 0; y < resized.height; y++) {
      for (int x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);

        final int r = pixel.r.toInt();
        final int g = pixel.g.toInt();
        final int b = pixel.b.toInt();

        final hsv = _rgbToHsv(r, g, b);

        final brightness = hsv[2];
        final saturation = hsv[1];

        // 🚫 Filter garbage colors
        if (brightness < 0.1) continue; // too dark
        if (brightness > 0.9) continue; // too light
        if (saturation < 0.15) continue; // too grey

        // Quantize color (reduce variations)
        final qr = (r ~/ 32) * 32;
        final qg = (g ~/ 32) * 32;
        final qb = (b ~/ 32) * 32;

        final key = (qr << 16) | (qg << 8) | qb;

        colorFrequency[key] = (colorFrequency[key] ?? 0) + 1;
      }
    }

    if (colorFrequency.isEmpty) {
      return Colors.grey; // fallback
    }

    // 🧠 Score colors
    int bestColorKey = colorFrequency.keys.first;
    double bestScore = 0;

    colorFrequency.forEach((key, freq) {
      final r = (key >> 16) & 0xFF;
      final g = (key >> 8) & 0xFF;
      final b = key & 0xFF;

      final hsv = _rgbToHsv(r, g, b);
      final saturation = hsv[1];
      final brightness = hsv[2];

      final score = freq * saturation * brightness;

      if (score > bestScore) {
        bestScore = score;
        bestColorKey = key;
      }
    });

    final r = (bestColorKey >> 16) & 0xFF;
    final g = (bestColorKey >> 8) & 0xFF;
    final b = bestColorKey & 0xFF;

    return Color.fromARGB(255, r, g, b);
  }

  /// RGB → HSV conversion
  /// Returns [h, s, v]
  static List<double> _rgbToHsv(int r, int g, int b) {
    final rf = r / 255;
    final gf = g / 255;
    final bf = b / 255;

    final maxVal = max(rf, max(gf, bf));
    final minVal = min(rf, min(gf, bf));
    final delta = maxVal - minVal;

    double h = 0;

    if (delta != 0) {
      if (maxVal == rf) {
        h = ((gf - bf) / delta) % 6;
      } else if (maxVal == gf) {
        h = ((bf - rf) / delta) + 2;
      } else {
        h = ((rf - gf) / delta) + 4;
      }
      h *= 60;
      if (h < 0) h += 360;
    }

    final double s = maxVal == 0 ? 0 : delta / maxVal;
    final v = maxVal;

    return [h, s, v];
  }
}