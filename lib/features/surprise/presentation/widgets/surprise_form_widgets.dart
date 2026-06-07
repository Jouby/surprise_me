import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Label de section utilisé dans les écrans de création et d'édition.
class SurpriseSectionLabel extends StatelessWidget {
  final String text;
  const SurpriseSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppTheme.textLight,
        ),
      ),
    );
  }
}
