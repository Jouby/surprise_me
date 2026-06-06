import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';

/// Form field used when creating a word-game element.
/// The creator types the word to guess; it is stored as plain uppercase text.
class WordGameFormField extends StatefulWidget {
  final String? initialValue;
  final void Function(String value) onChanged;
  final String? errorText;

  const WordGameFormField({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<WordGameFormField> createState() => _WordGameFormFieldState();
}

class _WordGameFormFieldState extends State<WordGameFormField> {
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
            labelText: context.l10n.wordToGuessLabel,
            hintText: context.l10n.wordToGuessHint,
            prefixIcon: const Icon(Icons.casino_outlined, size: 20),
            errorText: widget.errorText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.wordGameHint,
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
      TextEditingValue old, TextEditingValue value) =>
      value.copyWith(text: value.text.toUpperCase());
}
