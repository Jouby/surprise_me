import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class RemoveAccentsFormatter extends TextInputFormatter {
  static const _accented =
      'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÝýÿÑñÇç';
  static const _ascii =
      'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOOooooooUUUUuuuuYyyNnCc';

  static String normalize(String input) {
    final buffer = StringBuffer();
    for (final ch in input.runes) {
      final char = String.fromCharCode(ch);
      final idx = _accented.indexOf(char);
      buffer.write(idx >= 0 ? _ascii[idx] : char);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newValue,
  ) {
    final normalized = normalize(newValue.text);
    final lengthDiff = newValue.text.length - normalized.length;
    final newOffset = (newValue.selection.baseOffset - lengthDiff).clamp(
      0,
      normalized.length,
    );
    return newValue.copyWith(
      text: normalized,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
