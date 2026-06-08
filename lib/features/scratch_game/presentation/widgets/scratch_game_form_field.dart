import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../surprise/presentation/widgets/image_picker_field.dart';
import '../screens/scratch_game_screen.dart';

/// Champ de formulaire pour l'élément Gratte-moi.
/// Permet au créateur de choisir entre un message texte ou une image à révéler.
class ScratchGameFormField extends StatefulWidget {
  final String? initialValue;
  final void Function(String value) onChanged;
  final String? errorText;

  const ScratchGameFormField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<ScratchGameFormField> createState() => _ScratchGameFormFieldState();
}

class _ScratchGameFormFieldState extends State<ScratchGameFormField> {
  late bool _isImageMode;
  late final TextEditingController _textController;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    final init = widget.initialValue ?? '';
    _isImageMode = ScratchGameScreen.isImageContent(init);
    _textController = TextEditingController(text: _isImageMode ? '' : init);
    if (_isImageMode) _imageUrl = init;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _switchMode(bool imageMode) {
    setState(() {
      _isImageMode = imageMode;
      _textController.clear();
      _imageUrl = null;
    });
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Toggle Texte / Image ──────────────────────────────────────────
        Row(
          children: [
            _ModeChip(
              label: context.l10n.scratchContentTypeText,
              icon: Icons.text_fields_rounded,
              selected: !_isImageMode,
              onTap: () => _switchMode(false),
            ),
            const SizedBox(width: 8),
            _ModeChip(
              label: context.l10n.scratchContentTypeImage,
              icon: Icons.image_outlined,
              selected: _isImageMode,
              onTap: () => _switchMode(true),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // ── Champ selon le mode ───────────────────────────────────────────
        if (!_isImageMode) ...[
          TextField(
            controller: _textController,
            maxLines: 3,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              labelText: context.l10n.scratchMessageLabel,
              hintText: context.l10n.scratchMessageHint,
              alignLabelWithHint: true,
              errorText: widget.errorText,
            ),
          ),
        ] else ...[
          ImagePickerField(
            initialUrl: _imageUrl,
            onUploaded: (url) {
              setState(() => _imageUrl = url);
              widget.onChanged(url ?? '');
            },
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 14),
              child: Text(
                widget.errorText!,
                style: TextStyle(fontSize: 12, color: Colors.red.shade400),
              ),
            ),
          const SizedBox(height: 6),
          Text(
            context.l10n.scratchImageFormHint,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textLight,
              height: 1.4,
            ),
          ),
        ],
        if (!_isImageMode) ...[
          const SizedBox(height: 6),
          Text(
            context.l10n.scratchFormHint,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textLight,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Chip de sélection de mode ─────────────────────────────────────────────────

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? Colors.white : AppTheme.textMid,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : AppTheme.textMid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
