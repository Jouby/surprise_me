import 'package:flutter/material.dart';

class ColorUtils {
  static const String defaultHex = '#2E6DA4';

  /// Convertit un hex (#RRGGBB) en Color.
  static Color fromHex(String hex) {
    final clean = hex.replaceFirst('#', '');
    final value = int.tryParse(clean, radix: 16);
    if (value == null) return const Color(0xFF2E6DA4);
    return Color(0xFF000000 | value);
  }

  /// Convertit une Color en hex (#RRGGBB).
  static String toHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Génère une version plus claire de la couleur (pour dégradé).
  static Color lighten(Color color, [double amount = 0.25]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Retourne blanc ou noir selon le contraste avec la couleur de fond.
  static Color contrastText(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.35 ? Colors.black87 : Colors.white;
  }
}
