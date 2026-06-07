import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/l10n.dart';

import '../../domain/entities/element_draft.dart';
import '../../domain/entities/surprise.dart';
import '../../domain/entities/surprise_element.dart';
import '../providers/surprise_provider.dart';
import '../../domain/usecases/update_surprise_usecase.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../widgets/color_picker_sheet.dart';
import '../widgets/element_form_sheet.dart';
import '../widgets/emoji_picker_sheet.dart';

class EditSurpriseScreen extends StatefulWidget {
  final Surprise surprise;

  const EditSurpriseScreen({super.key, required this.surprise});

  @override
  State<EditSurpriseScreen> createState() => _EditSurpriseScreenState();
}

class _EditSurpriseScreenState extends State<EditSurpriseScreen> {
  late String _selectedEmoji;
  late String _selectedColor;
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late List<ElementDraft> _elements;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.surprise.emoji;
    _selectedColor = widget.surprise.color;
    _titleController = TextEditingController(text: widget.surprise.title);
    _subtitleController = TextEditingController(text: widget.surprise.subtitle);
    _elements = widget.surprise.elements.map(ElementDraft.fromElement).toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  // ─── Sauvegarde ──────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      _showSnack(context.l10n.titleRequired);
      return;
    }
    if (_elements.isEmpty) {
      _showSnack(context.l10n.addAtLeastOneElement);
      return;
    }
    if (_elements.any((e) => !e.isValid)) {
      _showSnack(context.l10n.completeAllElements);
      return;
    }

    setState(() => _saving = true);
    try {
      final updateUseCase = context.read<UpdateSurpriseUseCase>();
      await updateUseCase(
        UpdateSurpriseParams(
          surpriseId: widget.surprise.id,
          emoji: _selectedEmoji,
          title: _titleController.text.trim(),
          subtitle: _subtitleController.text.trim(),
          color: _selectedColor,
          originalElements: widget.surprise.elements,
          updatedElements: _elements,
        ),
      );

      if (!mounted) return;
      await context.read<SurpriseProvider>().load();
      if (!mounted) return;
      setState(() => _saving = false);
      context.pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _showSnack(context.l10n.errorPrefix(e.toString()));
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  // ─── Ajout / édition d'un élément ────────────────────────────────────────────

  void _openElementSheet({ElementDraft? initial, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ElementFormSheet(
        initial: initial,
        onConfirm: (draft) {
          setState(() {
            if (index != null) {
              _elements[index] = draft;
            } else {
              _elements.add(draft);
            }
          });
        },
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ),
        title: Text(
          context.l10n.editSurprise,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          _SectionLabel(context.l10n.identity),
          _buildIdentityCard(),
          const SizedBox(height: 24),
          _SectionLabel(context.l10n.elementsCount(_elements.length)),
          const SizedBox(height: 4),
          Text(
            context.l10n.editElementsHint,
            style: TextStyle(fontSize: 13, color: AppTheme.textLight),
          ),
          const SizedBox(height: 12),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _elements.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _elements.removeAt(oldIndex);
                _elements.insert(newIndex, item);
              });
            },
            itemBuilder: (_, index) => _ElementDraftTile(
              key: ValueKey(_elements[index].hashCode + index),
              draft: _elements[index],
              index: index,
              onEdit: () =>
                  _openElementSheet(initial: _elements[index], index: index),
              onDelete: () => setState(() => _elements.removeAt(index)),
              onDuplicate: () => setState(() {
                final src = _elements[index];
                _elements.insert(
                  index + 1,
                  ElementDraft(
                    type: src.type,
                    label: src.label,
                    content: src.content,
                    unlockCode: src.unlockCode,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          _buildAddElementButton(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => EmojiPickerSheet(
                    selected: _selectedEmoji,
                    onSelected: (e) => setState(() => _selectedEmoji = e),
                  ),
                ),
                child: Container(
                  width: 72,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.divider, width: 1.5),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        _selectedEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: context.l10n.titleLabel,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _subtitleController,
            decoration: InputDecoration(labelText: context.l10n.subtitleLabel),
          ),
          const SizedBox(height: 12),
          _buildColorRow(),
        ],
      ),
    );
  }

  Widget _buildColorRow() {
    final color = ColorUtils.fromHex(_selectedColor);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ColorPickerSheet(
          selected: _selectedColor,
          onSelected: (hex) => setState(() => _selectedColor = hex),
        ),
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

  Widget _buildAddElementButton() {
    return GestureDetector(
      onTap: () => _openElementSheet(),
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
            Icon(
              Icons.add_circle_outline_rounded,
              size: 18,
              color: AppTheme.primaryLight,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.addElement,
              style: TextStyle(
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

  Widget _buildBottomBar() {
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
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_rounded, size: 18),
          label: Text(_saving ? context.l10n.saving : context.l10n.saveButton),
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

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

class _ElementDraftTile extends StatelessWidget {
  final ElementDraft draft;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const _ElementDraftTile({
    super.key,
    required this.draft,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.drag_handle_rounded,
            size: 18,
            color: AppTheme.textLight,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _iconFor(draft.type),
                      size: 13,
                      color: AppTheme.primaryLight,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      draft.label.isEmpty
                          ? context.l10n.elementN(index + 1)
                          : draft.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppTheme.textDark,
                      ),
                    ),
                    if (draft.isNew) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentLight.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Builder(
                          builder: (ctx) => Text(
                            ctx.l10n.newBadge,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryLight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  draft.content.isEmpty ? '—' : draft.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMid),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Text(
                    context.l10n.codeLabel(draft.unlockCode.toUpperCase()),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 14,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onDuplicate,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: const Icon(
                    Icons.copy_all_rounded,
                    size: 14,
                    color: AppTheme.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 14,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ElementType type) {
    switch (type) {
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
