import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/surprise.dart';
import '../../domain/repositories/i_surprise_repository.dart';
import '../providers/surprise_provider.dart';
import '../../../unlock/presentation/providers/unlock_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/l10n/l10n.dart';
import '../widgets/element_tile.dart';
import '../../../unlock/presentation/widgets/unlock_bottom_sheet.dart';
import 'edit_surprise_screen.dart';

class SurpriseDetailScreen extends StatefulWidget {
  final Surprise surprise;
  final bool isOwner;
  final bool previewMode;

  const SurpriseDetailScreen({
    super.key,
    required this.surprise,
    this.isOwner = false,
    this.previewMode = false,
  });

  @override
  State<SurpriseDetailScreen> createState() => _SurpriseDetailScreenState();
}

class _SurpriseDetailScreenState extends State<SurpriseDetailScreen> {
  Surprise get surprise => widget.surprise;
  bool get isOwner => widget.isOwner;
  bool get previewMode => widget.previewMode;

  bool _tokenMissing = false;

  @override
  void initState() {
    super.initState();
    if (isOwner) _checkToken();
  }

  Future<void> _checkToken() async {
    final repo = context.read<ISurpriseRepository>();
    final token = await repo.getCreatorToken(surprise.id);
    if (mounted) setState(() => _tokenMissing = token == null);
  }

  void _showUnlockSheet(BuildContext context, UnlockProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UnlockBottomSheet(
        provider: provider,
        themeColor: ColorUtils.fromHex(surprise.color),
      ),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShareSheet(
        surprise: surprise,
        themeColor: ColorUtils.fromHex(surprise.color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isOwner) return _buildOwnerView(context);
    if (previewMode) return _buildPreviewView(context);

    return Consumer<UnlockProvider>(
      builder: (context, provider, _) {
        final unlockedCount =
            surprise.elements.where((e) => provider.isUnlocked(e.unlockCode)).length;
        final total = surprise.elements.length;

        return Scaffold(
          backgroundColor: AppTheme.surface,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        children: [
                          _buildHero(context),
                          const SizedBox(height: 20),
                          _buildProgressBar(context, unlockedCount, total),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ElementTile(
                        element: surprise.elements[index],
                        isUnlocked: provider.isUnlocked(
                            surprise.elements[index].unlockCode),
                        themeColor: ColorUtils.fromHex(surprise.color),
                      ),
                      childCount: surprise.elements.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(context, provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final themeColor = ColorUtils.fromHex(surprise.color);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppTheme.cardBg,
        title: Text(ctx.l10n.deleteDialogTitle),
        content: Text(
          isOwner
              ? ctx.l10n.deleteOwnerContent
              : ctx.l10n.deleteGuestContent,
          style: const TextStyle(fontSize: 14, color: AppTheme.textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel,
                style: const TextStyle(color: AppTheme.textLight)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isOwner ? ctx.l10n.delete : ctx.l10n.remove,
              style: const TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await context.read<SurpriseProvider>().deleteSurprise(
            surpriseId: surprise.id,
            shareCode: surprise.shareCode,
            isOwner: isOwner,
          );
      if (context.mounted) Navigator.pop(context); // retour à l'accueil
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.l10n.errorPrefix(e.toString())),
          behavior: SnackBarBehavior.floating,
          backgroundColor: themeColor,
        ));
      }
    }
  }

  void _openEdit(BuildContext context) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditSurpriseScreen(surprise: surprise),
      ),
    );
    // Si des modifs ont été sauvegardées, on récupère la version fraîche
    // depuis le provider et on remplace la surprise dans la navigation.
    if (updated == true && context.mounted) {
      final provider = context.read<SurpriseProvider>();
      final fresh = provider.surprises
          .where((s) => s.id == surprise.id)
          .firstOrNull;
      if (fresh != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SurpriseDetailScreen(
              surprise: fresh,
              isOwner: true,
            ),
          ),
        );
      }
    }
  }

  Widget _buildOwnerView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildOwnerAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    children: [
                      _buildHero(context),
                      const SizedBox(height: 16),
                      _buildOwnerBanner(context),
                      if (_tokenMissing) ...[
                        const SizedBox(height: 10),
                        _buildTokenMissingBanner(context),
                      ],
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ElementTile(
                    element: surprise.elements[index],
                    isUnlocked: true,
                    ownerMode: true,
                    themeColor: ColorUtils.fromHex(surprise.color),
                  ),
                  childCount: surprise.elements.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildOwnerBottomBar(context),
          ),
        ],
      ),
    );
  }

  // ─── Mode prévisualisation ────────────────────────────────────────────────

  Widget _buildPreviewView(BuildContext context) {
    final total = surprise.elements.length;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      _buildHero(context),
                      const SizedBox(height: 12),
                      _buildPreviewBanner(context),
                      const SizedBox(height: 8),
                      _buildProgressBar(context, total, total),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ElementTile(
                    element: surprise.elements[index],
                    isUnlocked: true,
                    themeColor: ColorUtils.fromHex(surprise.color),
                  ),
                  childCount: total,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildPreviewBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewBanner(BuildContext context) {
    const previewColor = Color(0xFF7C5CBF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: previewColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: previewColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility_rounded, size: 18, color: previewColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.previewBanner,
              style: const TextStyle(
                fontSize: 12,
                color: previewColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewBottomBar(BuildContext context) {
    const previewColor = Color(0xFF7C5CBF);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: previewColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.visibility_off_rounded, size: 18),
          label: Text(context.l10n.exitPreview),
          style: OutlinedButton.styleFrom(
            foregroundColor: previewColor,
            side: const BorderSide(color: previewColor, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerBanner(BuildContext context) {
    final themeColor = ColorUtils.fromHex(surprise.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: themeColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.edit_note_rounded, size: 18, color: themeColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.ownerBanner,
              style: TextStyle(
                fontSize: 12,
                color: themeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenMissingBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTokenRecoveryDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.link_rounded, size: 18, color: Colors.orange),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Cet appareil n\'est pas lié à cette surprise. Appuyez pour entrer le code d\'accès.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Future<void> _showTokenRecoveryDialog(BuildContext context) async {
    final linked = await showDialog<bool>(
      context: context,
      builder: (_) => _TokenRecoveryDialog(
        surpriseId: surprise.id,
        repo: context.read<ISurpriseRepository>(),
      ),
    );
    if (linked == true && mounted) setState(() => _tokenMissing = false);
  }

  Widget _buildOwnerBottomBar(BuildContext context) {
    final themeColor = ColorUtils.fromHex(surprise.color);
    const previewColor = Color(0xFF7C5CBF);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          // Bouton aperçu
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurpriseDetailScreen(
                  surprise: surprise,
                  previewMode: true,
                ),
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: previewColor,
              side: const BorderSide(color: previewColor, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Icon(Icons.visibility_rounded, size: 18),
          ),
          const SizedBox(width: 12),
          // Bouton partager
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showShareSheet(context),
              icon: const Icon(Icons.share_rounded, size: 16),
              label: Text(context.l10n.shareWithCode(surprise.shareCode)),
              style: OutlinedButton.styleFrom(
                foregroundColor: themeColor,
                side: BorderSide(color: themeColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildOwnerAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.surface,
      surfaceTintColor: Colors.transparent,
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
            child: const Icon(Icons.arrow_back_ios_rounded,
                size: 16, color: AppTheme.textDark),
          ),
        ),
      ),
      title: Text(
        surprise.title,
        style:
            Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: GestureDetector(
            onTap: () => _openEdit(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Icon(Icons.edit_rounded,
                  size: 16, color: ColorUtils.fromHex(surprise.color)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => _confirmDelete(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.surface,
      surfaceTintColor: Colors.transparent,
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
            child: const Icon(Icons.arrow_back_ios_rounded,
                size: 16, color: AppTheme.textDark),
          ),
        ),
      ),
      title: Text(
        surprise.title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: GestureDetector(
            onTap: () => _showShareSheet(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Icon(Icons.share_rounded,
                  size: 16, color: ColorUtils.fromHex(surprise.color)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => _confirmDelete(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.divider),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    final themeColor = ColorUtils.fromHex(surprise.color);
    final themeLight = ColorUtils.lighten(themeColor);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [themeColor, themeLight],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(surprise.emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 10),
          Text(
            surprise.title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            surprise.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13, color: Colors.white.withValues(alpha: 0.75)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, int unlocked, int total) {
    final themeColor = ColorUtils.fromHex(surprise.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.revealedElements,
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMid,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '$unlocked / $total',
                style: TextStyle(
                    fontSize: 13,
                    color: themeColor,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? unlocked / total : 0,
              minHeight: 6,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation(themeColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, UnlockProvider provider) {
    final themeColor = ColorUtils.fromHex(surprise.color);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.08),
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
          onPressed: () => _showUnlockSheet(context, provider),
          icon: const Icon(Icons.vpn_key_outlined, size: 18),
          label: Text(context.l10n.enterCode),
          style: ElevatedButton.styleFrom(backgroundColor: themeColor),
        ),
      ),
    );
  }
}

// ─── Token recovery dialog ───────────────────────────────────────────────────

class _TokenRecoveryDialog extends StatefulWidget {
  final String surpriseId;
  final ISurpriseRepository repo;

  const _TokenRecoveryDialog({
    required this.surpriseId,
    required this.repo,
  });

  @override
  State<_TokenRecoveryDialog> createState() => _TokenRecoveryDialogState();
}

class _TokenRecoveryDialogState extends State<_TokenRecoveryDialog> {
  final _controller = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = _controller.text.trim();
    if (token.isEmpty) return;

    setState(() { _loading = true; _error = null; });

    final valid = await widget.repo.verifyAndSaveCreatorToken(
      surpriseId: widget.surpriseId,
      token: token,
    );

    if (!mounted) return;

    if (valid) {
      Navigator.pop(context, true);
    } else {
      setState(() { _loading = false; _error = 'Token invalide.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.cardBg,
      title: const Text('Lier cet appareil'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entrez le creator_token associé à cette surprise dans Supabase.',
            style: TextStyle(fontSize: 13, color: AppTheme.textMid),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (_) { if (_error != null) setState(() => _error = null); },
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Creator token (UUID)',
              hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
              errorText: _error,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.cancel,
              style: const TextStyle(color: AppTheme.textLight)),
        ),
        TextButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Lier',
                  style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// ─── Share sheet ──────────────────────────────────────────────────────────────

class _ShareSheet extends StatelessWidget {
  final Surprise surprise;
  final Color themeColor;

  const _ShareSheet({required this.surprise, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            surprise.emoji,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.shareSheetTitle(surprise.title),
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.shareAccessHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textLight, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider, width: 1.5),
            ),
            child: Text(
              surprise.shareCode,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 8,
                color: themeColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final link = 'https://jouby.github.io/surprise_me/join/${surprise.shareCode}';
                    Clipboard.setData(ClipboardData(text: link));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.linkCopiedClipboard),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: themeColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: Text(context.l10n.copy),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: themeColor,
                    side: BorderSide(color: themeColor.withValues(alpha: 0.4), width: 1.5),
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
                    final link = 'https://jouby.github.io/surprise_me/join/${surprise.shareCode}';
                    Share.share(
                      context.l10n.shareMessage(link, surprise.shareCode),
                    );
                  },
                  icon: const Icon(Icons.share_rounded, size: 16),
                  label: Text(context.l10n.share),
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
