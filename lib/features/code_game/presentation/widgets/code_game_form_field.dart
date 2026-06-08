import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/code_game_state.dart';

/// Champ de formulaire utilisé lors de la création d'un élément Code Secret.
/// Le créateur tape le code à [codeLength] chiffres à faire deviner.
class CodeGameFormField extends StatefulWidget {
  final String? initialValue;
  final void Function(String value) onChanged;
  final String? errorText;

  const CodeGameFormField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<CodeGameFormField> createState() => _CodeGameFormFieldState();
}

class _CodeGameFormFieldState extends State<CodeGameFormField> {
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
          keyboardType: TextInputType.number,
          maxLength: CodeGameState.codeLength,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: context.l10n.codeGameSecretLabel,
            hintText: context.l10n.codeGameSecretHint,
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            errorText: widget.errorText,
            counterText: '',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.codeGameFormHint,
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
