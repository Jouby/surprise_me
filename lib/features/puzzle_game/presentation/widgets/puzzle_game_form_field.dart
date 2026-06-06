import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/surprise/presentation/widgets/image_picker_field.dart';

/// Form field for creating a puzzle element.
/// The user picks an image; it is stored as a plain URL in content.
class PuzzleGameFormField extends StatelessWidget {
  final String? initialUrl;
  final ValueChanged<String?> onUploaded;
  final String? errorText;

  const PuzzleGameFormField({
    super.key,
    this.initialUrl,
    required this.onUploaded,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagePickerField(
          initialUrl: initialUrl,
          onUploaded: onUploaded,
        ),
        const SizedBox(height: 6),
        Text(
          'L\'image sera découpée en 9 pièces mélangées. Le joueur devra les remettre dans le bon ordre.',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textLight,
            height: 1.4,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: Text(
              errorText!,
              style: TextStyle(fontSize: 12, color: Colors.red.shade400),
            ),
          ),
      ],
    );
  }
}
