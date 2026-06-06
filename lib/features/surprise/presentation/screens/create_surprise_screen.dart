import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/element_draft.dart';
import '../../domain/entities/surprise_element.dart';
import '../providers/surprise_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../widgets/color_picker_sheet.dart';
import '../widgets/element_form_sheet.dart';
import '../widgets/emoji_picker_sheet.dart';

class CreateSurpriseScreen extends StatefulWidget {
  const CreateSurpriseScreen({super.key});

  @override
  State<CreateSurpriseScreen> createState() => _CreateSurpriseScreenState();
}

class _CreateSurpriseScreenState extends State<CreateSurpriseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedEmoji = '🎁';
  String _selectedColor = ColorUtils.defaultHex;
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  final List<ElementDraft> _elements = [];
  bool _saving = false;
  String? _createdCode;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_elements.isEmpty) {
      _showSnack('Ajoutez au moins un élément.');
      return;
    }
    if (_elements.any((e) => !e.isValid)) {
      _showSnack('Complétez tous les éléments.');
      return;
    }

    setState(() => _saving = true);
    try {
      final code = await context.read<SurpriseProvider>().create(
            emoji: _selectedEmoji,
            title: _titleController.text.trim(),
            subtitle: _subtitleController.text.trim(),
            color: _selectedColor,
            elements: _elements.map((e) => e.toMap()).toList(),
          );
      setState(() {
        _saving = false;
        _createdCode = code;
      });
    } catch (e) {
      setState(() => _saving = false);
      _showSnack('Erreur : $e');
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

  void _addElement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ElementFormSheet(
        onConfirm: (draft) => setState(() => _elements.add(draft)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_createdCode != null) return _buildSuccessView();

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textDark),
            ),
          ),
        ),
        title: Text(
          'Créer une surprise',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: [
            _SectionLabel('Identité'),
            _buildIdentityFields(),
            const SizedBox(height: 24),
            _SectionLabel('Éléments (${_elements.length})'),
            const SizedBox(height: 4),
            Text(
              'Chaque élément peut être révélé par un code distinct.',
              style: TextStyle(fontSize: 13, color: AppTheme.textLight),
            ),
            const SizedBox(height: 12),
            ..._elements.asMap().entries.map((e) => _ElementDraftTile(
                  draft: e.value,
                  index: e.key,
                  onDelete: () => setState(() => _elements.removeAt(e.key)),
                  onDuplicate: () => setState(() => _elements.insert(
                        e.key + 1,
                        ElementDraft(
                          type: e.value.type,
                          label: e.value.label,
                          content: e.value.content,
                          unlockCode: e.value.unlockCode,
                        ),
                      )),
                )),
            _buildAddElementButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildIdentityFields() {
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
                      Text(_selectedEmoji, style: const TextStyle(fontSize: 28)),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit_rounded,
                              size: 8, color: Colors.white),
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
                  decoration: const InputDecoration(labelText: 'Titre *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requis' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _subtitleController,
            decoration: const InputDecoration(labelText: 'Sous-titre (optionnel)'),
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
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Couleur thème',
                style: TextStyle(fontSize: 14, color: AppTheme.textMid),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildAddElementButton() {
    return GestureDetector(
      onTap: _addElement,
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
            Icon(Icons.add_circle_outline_rounded, size: 18, color: AppTheme.primaryLight),
            const SizedBox(width: 8),
            Text(
              'Ajouter un élément',
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
          20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.check_rounded, size: 18),
          label: Text(_saving ? 'Création…' : 'Créer la surprise'),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.celebration_rounded,
                    size: 48, color: AppTheme.primary),
              ),
              const SizedBox(height: 24),
              Text(
                'Surprise créée !',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 10),
              Text(
                'Partagez ce code pour que vos proches\npuissent découvrir la surprise.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textLight, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.divider, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Text(
                  _createdCode!,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 8,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final link = 'https://jouby.github.io/surprise_me/join/$_createdCode';
                        Clipboard.setData(ClipboardData(text: link));
                        _showSnack('Lien copié !');
                      },
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Copier'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: AppTheme.divider, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final link = 'https://jouby.github.io/surprise_me/join/$_createdCode';
                        Share.share(
                          'J\'ai une surprise pour toi ! 🎁\nOuvre ce lien pour la découvrir : $link\n\nOu entre le code manuellement : $_createdCode',
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 16),
                      label: const Text('Partager'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Retour à l\'accueil',
                  style: TextStyle(color: AppTheme.textLight, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section label ───────────────────────────────────────────────────────────

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

// ─── Element draft tile (création) ───────────────────────────────────────────

class _ElementDraftTile extends StatelessWidget {
  final ElementDraft draft;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const _ElementDraftTile({
    required this.draft,
    required this.index,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconFor(draft.type), size: 15, color: AppTheme.primaryLight),
              const SizedBox(width: 6),
              Text(
                draft.label.isEmpty ? 'Élément ${index + 1}' : draft.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppTheme.textDark,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onDuplicate,
                child: const Icon(Icons.copy_all_rounded,
                    size: 16, color: AppTheme.textLight),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.close_rounded,
                    size: 18, color: AppTheme.textLight),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            draft.content.isEmpty ? '—' : draft.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppTheme.textMid),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Text(
              'Code : ${draft.unlockCode.toUpperCase()}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryLight,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ElementType type) {
    switch (type) {
      case ElementType.text: return Icons.notes_rounded;
      case ElementType.image: return Icons.photo_outlined;
      case ElementType.date: return Icons.calendar_today_outlined;
      case ElementType.location: return Icons.place_outlined;
      case ElementType.wordGame: return Icons.casino_outlined;
      case ElementType.puzzle:   return Icons.grid_view_rounded;
    }
  }
}
