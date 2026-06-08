import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/surprise_element.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../widgets/color_picker_sheet.dart';

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

/// Ligne de sélection de couleur thème (create & edit screens).
class SurpriseColorRow extends StatelessWidget {
  final String selectedColor;
  final ValueChanged<String> onSelected;

  const SurpriseColorRow({
    super.key,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = ColorUtils.fromHex(selectedColor);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            ColorPickerSheet(selected: selectedColor, onSelected: onSelected),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.themeColor,
                style: const TextStyle(fontSize: 14, color: AppTheme.textMid),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppTheme.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bouton "Ajouter un élément" (create & edit screens).
class AddElementButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddElementButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline_rounded,
              size: 18,
              color: AppTheme.primaryLight,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.addElement,
              style: const TextStyle(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension présentation : icône Material associée à un type d'élément.
/// Centralisée ici pour éviter la redéfinition dans ElementTile et les
/// deux _ElementDraftTile (create / edit screens).
extension ElementTypeIcon on ElementType {
  IconData get icon {
    switch (this) {
      case ElementType.text:
        return Icons.notes_rounded;
      case ElementType.image:
        return Icons.photo_outlined;
      case ElementType.date:
        return Icons.calendar_today_outlined;
      case ElementType.location:
        return Icons.place_outlined;
      case ElementType.wordGame:
        return Icons.casino_outlined;
      case ElementType.puzzle:
        return Icons.grid_view_rounded;
      case ElementType.motusGame:
        return Icons.keyboard_rounded;
      case ElementType.scratchGame:
        return Icons.auto_awesome_rounded;
      case ElementType.codeGame:
        return Icons.lock_outline_rounded;
    }
  }
}

/// Barre du bas avec bouton de sauvegarde (create & edit screens).
class SurpriseSaveBottomBar extends StatelessWidget {
  final bool saving;
  final VoidCallback? onSave;
  final String label;

  const SurpriseSaveBottomBar({
    super.key,
    required this.saving,
    required this.onSave,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: saving ? null : onSave,
          icon: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_rounded, size: 18),
          label: Text(label),
        ),
      ),
    );
  }
}
