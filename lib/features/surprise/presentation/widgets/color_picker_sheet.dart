import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';

/// Palette de couleurs proposées dans le picker.
const _palette = [
  ('Bleu', '#2E6DA4'),
  ('Marine', '#1A3A5C'),
  ('Indigo', '#3949AB'),
  ('Violet', '#7B1FA2'),
  ('Prune', '#880E4F'),
  ('Rose', '#C2185B'),
  ('Rouge', '#C62828'),
  ('Corail', '#E64A19'),
  ('Ambre', '#F57F17'),
  ('Vert forêt', '#2E7D32'),
  ('Émeraude', '#00695C'),
  ('Sarcelle', '#00838F'),
  ('Ardoise', '#37474F'),
  ('Brun', '#4E342E'),
  ('Gris bleuté', '#546E7A'),
  ('Noir', '#212121'),
];

class ColorPickerSheet extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const ColorPickerSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Couleur thème',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 18),
              ),
              const Spacer(),
              // Aperçu de la couleur sélectionnée
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: ColorUtils.fromHex(selected),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.divider, width: 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Personnalise l\'apparence de l\'écran de surprise.',
            style: TextStyle(fontSize: 13, color: AppTheme.textLight),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: _palette.length,
            itemBuilder: (_, i) {
              final (label, hex) = _palette[i];
              final isSelected = hex == selected;
              final color = ColorUtils.fromHex(hex);
              return Tooltip(
                message: label,
                child: GestureDetector(
                  onTap: () {
                    onSelected(hex);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: isSelected ? 0.6 : 0.25),
                          blurRadius: isSelected ? 10 : 4,
                          spreadRadius: isSelected ? 1 : 0,
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                            size: 18, color: Colors.white)
                        : null,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
