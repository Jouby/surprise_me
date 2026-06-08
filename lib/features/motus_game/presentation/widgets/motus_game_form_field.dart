import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';

/// Champ de formulaire utilisé lors de la création d'un élément Motus.
/// Le créateur tape le mot à deviner ; il est stocké en majuscules dans content.
class MotusGameFormField extends StatefulWidget {
  final String? initialValue;
  final void Function(String value) onChanged;
  final String? errorText;

  const MotusGameFormField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<MotusGameFormField> createState() => _MotusGameFormFieldState();
}

class _MotusGameFormFieldState extends State<MotusGameFormField> {
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
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
            _UpperCaseFormatter(),
          ],
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: context.l10n.motusWordLabel,
            hintText: context.l10n.motusWordHint,
            prefixIcon: const Icon(Icons.abc_rounded, size: 22),
            errorText: widget.errorText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.motusFormHint,
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

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue value,
  ) => value.copyWith(text: value.text.toUpperCase());
}
