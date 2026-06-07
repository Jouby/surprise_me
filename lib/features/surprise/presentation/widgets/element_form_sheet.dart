import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/l10n.dart';

import '../../domain/entities/element_draft.dart';
import '../../domain/entities/surprise_element.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/text_formatters.dart';
import '../../../../features/word_game/presentation/widgets/word_game_form_field.dart';
import '../../../../features/puzzle_game/presentation/widgets/puzzle_game_form_field.dart';
import 'image_picker_field.dart';
import 'location_autocomplete_field.dart';

/// Bottom sheet de création / édition d'un élément.
/// Si [initial] est fourni, le formulaire est pré-rempli (mode édition).
class ElementFormSheet extends StatefulWidget {
  final ElementDraft? initial;
  final void Function(ElementDraft) onConfirm;

  const ElementFormSheet({super.key, this.initial, required this.onConfirm});

  @override
  State<ElementFormSheet> createState() => _ElementFormSheetState();
}

class _ElementFormSheetState extends State<ElementFormSheet> {
  late ElementType _type;
  late final TextEditingController _labelController;
  late final TextEditingController _contentController;
  late final TextEditingController _codeController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _uploadedImageUrl;
  String _wordGameWord = '';
  String? _puzzleImageUrl;
  bool _submitted = false; // true dès le premier appui sur Ajouter/Enregistrer

  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    _type = init?.type ?? ElementType.text;
    _labelController = TextEditingController(text: init?.label ?? '');
    _contentController = TextEditingController(
      text:
          (init != null &&
              init.type != ElementType.date &&
              init.type != ElementType.image)
          ? init.content
          : '',
    );
    if (init != null && init.type == ElementType.wordGame) {
      _wordGameWord = init.content;
    }
    if (init != null && init.type == ElementType.puzzle) {
      _puzzleImageUrl = init.content;
    }
    _codeController = TextEditingController(text: init?.unlockCode ?? '');

    if (init != null && init.type == ElementType.date) {
      _parseInitialDate(init.content);
    }
    if (init != null && init.type == ElementType.image) {
      _uploadedImageUrl = init.content;
    }
  }

  void _parseInitialDate(String content) {
    // Format: "Samedi 12 Juillet 2025 · 19h30"
    try {
      final months = {
        'Janvier': 1,
        'Février': 2,
        'Mars': 3,
        'Avril': 4,
        'Mai': 5,
        'Juin': 6,
        'Juillet': 7,
        'Août': 8,
        'Septembre': 9,
        'Octobre': 10,
        'Novembre': 11,
        'Décembre': 12,
      };
      final parts = content.split(' · ');
      final datePart = parts[0];
      final tokens = datePart.split(' ');
      // tokens: [Samedi, 12, Juillet, 2025]
      if (tokens.length >= 4) {
        final day = int.tryParse(tokens[1]);
        final month = months[tokens[2]];
        final year = int.tryParse(tokens[3]);
        if (day != null && month != null && year != null) {
          _selectedDate = DateTime(year, month, day);
        }
      }
      if (parts.length > 1) {
        // "19h30"
        final timePart = parts[1].replaceAll('h', ':');
        final timeParts = timePart.split(':');
        if (timeParts.length == 2) {
          final h = int.tryParse(timeParts[0]);
          final m = int.tryParse(timeParts[1]);
          if (h != null && m != null) {
            _selectedTime = TimeOfDay(hour: h, minute: m);
          }
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _labelController.dispose();
    _contentController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String _generateCode() {
    final rng = Random.secure();
    return List.generate(6, (_) => _chars[rng.nextInt(_chars.length)]).join();
  }

  String get _dateContent {
    if (_selectedDate == null) return '';
    final d = _selectedDate!;
    final weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    final months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    final base =
        '${weekdays[d.weekday - 1]} ${d.day} ${months[d.month - 1]} ${d.year}';
    if (_selectedTime != null) {
      final h = _selectedTime!.hour.toString().padLeft(2, '0');
      final m = _selectedTime!.minute.toString().padLeft(2, '0');
      return '$base · ${h}h$m';
    }
    return base;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('fr'),
    );
    if (date == null) return;
    setState(() => _selectedDate = date);
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    setState(() => _selectedTime = time);
  }

  String? _contentError(BuildContext context) {
    if (!_submitted) return null;
    switch (_type) {
      case ElementType.date:
        return _selectedDate == null ? context.l10n.pleaseSelectDate : null;
      case ElementType.image:
        return _uploadedImageUrl == null ? context.l10n.pleaseAddImage : null;
      case ElementType.location:
        return _contentController.text.trim().isEmpty
            ? context.l10n.pleaseEnterLocation
            : null;
      case ElementType.wordGame:
        return _wordGameWord.trim().isEmpty
            ? context.l10n.pleaseEnterWord
            : null;
      case ElementType.puzzle:
        return _puzzleImageUrl == null ? context.l10n.pleaseAddImage : null;
      case ElementType.text:
        return _contentController.text.trim().isEmpty
            ? context.l10n.fieldRequired
            : null;
    }
  }

  void _submit() {
    setState(() => _submitted = true);

    final label = _labelController.text.trim();
    final code = _codeController.text.trim();
    String content;
    if (_type == ElementType.date) {
      content = _dateContent;
    } else if (_type == ElementType.image) {
      content = _uploadedImageUrl ?? '';
    } else if (_type == ElementType.wordGame) {
      content = _wordGameWord.trim().toUpperCase();
    } else if (_type == ElementType.puzzle) {
      content = _puzzleImageUrl ?? '';
    } else {
      content = _contentController.text.trim();
    }

    if (label.isEmpty || content.isEmpty || code.isEmpty) return;

    widget.onConfirm(
      ElementDraft(
        id: widget.initial?.id,
        type: _type,
        label: label,
        content: content,
        unlockCode: code.toUpperCase(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
      child: SingleChildScrollView(
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
            Text(
              _isEditing ? context.l10n.editElement : context.l10n.newElement,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Type selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ElementType.values.map((t) {
                  final selected = t == _type;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _type = t;
                      _selectedDate = null;
                      _selectedTime = null;
                      _uploadedImageUrl = null;
                      _wordGameWord = '';
                      _puzzleImageUrl = null;
                      _contentController.clear();
                      _submitted = false;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.primary : AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected ? AppTheme.primary : AppTheme.divider,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _iconFor(t),
                            size: 14,
                            color: selected ? Colors.white : AppTheme.textMid,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _labelFor(t),
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
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _labelController,
              onChanged: (_) {
                if (_submitted) setState(() {});
              },
              decoration: InputDecoration(
                labelText: context.l10n.elementTitleLabel,
                errorText: (_submitted && _labelController.text.trim().isEmpty)
                    ? context.l10n.fieldRequired
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            // Champ contenu selon le type
            if (_type == ElementType.date) ...[
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _contentError(context) != null
                          ? Colors.red.shade400
                          : AppTheme.divider,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: _contentError(context) != null
                            ? Colors.red.shade400
                            : AppTheme.primaryLight,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? context.l10n.selectDate
                              : _dateContent,
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedDate == null
                                ? AppTheme.textLight
                                : AppTheme.textDark,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppTheme.textLight,
                      ),
                    ],
                  ),
                ),
              ),
              if (_contentError(context) != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 14),
                  child: Text(
                    _contentError(context)!,
                    style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                  ),
                ),
            ] else if (_type == ElementType.image) ...[
              ImagePickerField(
                initialUrl: _uploadedImageUrl,
                onUploaded: (url) => setState(() => _uploadedImageUrl = url),
              ),
              if (_contentError(context) != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 14),
                  child: Text(
                    _contentError(context)!,
                    style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                  ),
                ),
            ] else if (_type == ElementType.location)
              LocationAutocompleteField(
                initialValue: _contentController.text.isNotEmpty
                    ? _contentController.text
                    : null,
                onSelected: (v) {
                  _contentController.text = v;
                  if (_submitted) setState(() {});
                },
                errorText: _contentError(context),
              )
            else if (_type == ElementType.puzzle)
              PuzzleGameFormField(
                initialUrl: _puzzleImageUrl,
                onUploaded: (url) => setState(() => _puzzleImageUrl = url),
                errorText: _contentError(context),
              )
            else if (_type == ElementType.wordGame)
              WordGameFormField(
                initialValue: _wordGameWord.isNotEmpty ? _wordGameWord : null,
                onChanged: (v) {
                  _wordGameWord = v;
                  if (_submitted) setState(() {});
                },
                errorText: _contentError(context),
              )
            else
              TextField(
                controller: _contentController,
                maxLines: _type == ElementType.text ? 3 : 1,
                onChanged: (_) {
                  if (_submitted) setState(() {});
                },
                decoration: InputDecoration(
                  labelText: _contentHint(context, _type),
                  errorText: _contentError(context),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                      UpperCaseTextFormatter(),
                    ],
                    onChanged: (_) {
                      if (_submitted) setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: context.l10n.unlockCodeLabel,
                      hintText: context.l10n.unlockCodeHint,
                      errorText:
                          (_submitted && _codeController.text.trim().isEmpty)
                          ? context.l10n.fieldRequired
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: context.l10n.generateCode,
                  child: InkWell(
                    onTap: () =>
                        setState(() => _codeController.text = _generateCode()),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.divider, width: 1.5),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 20,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(
                  _isEditing ? Icons.check_rounded : Icons.add_rounded,
                  size: 18,
                ),
                label: Text(_isEditing ? context.l10n.save : context.l10n.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(ElementType t) {
    final l = context.l10n;
    switch (t) {
      case ElementType.text:
        return l.elementTypeText;
      case ElementType.image:
        return l.elementTypeImage;
      case ElementType.date:
        return l.elementTypeDate;
      case ElementType.location:
        return l.elementTypeLocation;
      case ElementType.wordGame:
        return l.elementTypeWordGame;
      case ElementType.puzzle:
        return l.elementTypePuzzle;
    }
  }

  String _contentHint(BuildContext context, ElementType t) {
    final l = context.l10n;
    switch (t) {
      case ElementType.text:
        return l.messageContent;
      case ElementType.image:
        return l.elementTypeImage;
      case ElementType.date:
        return l.selectDate;
      case ElementType.location:
        return l.pleaseEnterLocation;
      case ElementType.wordGame:
        return l.wordToGuessLabel;
      case ElementType.puzzle:
        return l.pleaseAddImage;
    }
  }

  IconData _iconFor(ElementType t) {
    switch (t) {
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
    }
  }
}
