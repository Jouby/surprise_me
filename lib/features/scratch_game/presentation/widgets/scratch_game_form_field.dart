import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';

/// Champ de formulaire utilisé lors de la création d'un élément Gratte-moi.
/// Le créateur tape le message à révéler après grattage.
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
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          maxLines: 3,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: context.l10n.scratchMessageLabel,
            hintText: context.l10n.scratchMessageHint,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.auto_awesome_rounded, size: 20),
            ),
            errorText: widget.errorText,
            alignLabelWithHint: true,
          ),
        ),
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
    );
  }
}
