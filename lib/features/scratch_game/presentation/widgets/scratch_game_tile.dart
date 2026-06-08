import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../data/datasources/scratch_local_datasource.dart';
import '../screens/scratch_game_screen.dart';

/// Widget affiché dans l'ElementTile pour le type Gratte-moi.
///
/// - Si l'élément n'a pas encore été gratté : affiche un bouton qui ouvre
///   [ScratchGameScreen] en plein écran.
/// - Si l'élément a déjà été gratté (état persisté) : affiche directement
///   le contenu révélé (texte ou image).
class ScratchGameTile extends StatefulWidget {
  final String elementId;
  final String content;
  final Color themeColor;

  const ScratchGameTile({
    super.key,
    required this.elementId,
    required this.content,
    this.themeColor = AppTheme.primaryLight,
  });

  @override
  State<ScratchGameTile> createState() => _ScratchGameTileState();
}

class _ScratchGameTileState extends State<ScratchGameTile> {
  final _ds = ScratchLocalDatasource();
  bool? _isScratched; // null = chargement en cours

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final scratched = await _ds.isScratched(widget.elementId);
    if (mounted) setState(() => _isScratched = scratched);
  }

  Future<void> _openScratchScreen() async {
    final revealed = await context.push<bool>(
      '/scratch',
      extra: ScratchRouteArgs(
        elementId: widget.elementId,
        content: widget.content,
        themeColor: widget.themeColor,
      ),
    );
    if (revealed == true && mounted) {
      await _ds.markScratched(widget.elementId);
      setState(() => _isScratched = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: _isScratched == null
          ? _buildLoading()
          : _isScratched!
          ? _buildRevealed(context)
          : _buildPlayButton(context),
    );
  }

  // ── Chargement ────────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return SizedBox(
      height: 60,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: widget.themeColor,
          ),
        ),
      ),
    );
  }

  // ── Contenu révélé ────────────────────────────────────────────────────────

  Widget _buildRevealed(BuildContext context) {
    final isImage = ScratchGameScreen.isImageContent(widget.content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.content,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                color: AppTheme.surface,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppTheme.textLight,
                    size: 32,
                  ),
                ),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.themeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.themeColor.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Text(
              widget.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: widget.themeColor,
                height: 1.4,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 13,
              color: Colors.green.shade500,
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.scratchRevealed,
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Bouton jouer ──────────────────────────────────────────────────────────

  Widget _buildPlayButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Aperçu du calque argenté (décoratif)
        Container(
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                const Color(0xFFB0BEC5),
                const Color(0xFFCFD8DC),
                const Color(0xFFB0BEC5),
              ],
              stops: const [0, 0.5, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _openScratchScreen,
            icon: Icon(
              Icons.back_hand_rounded,
              size: 16,
              color: widget.themeColor,
            ),
            label: Text(
              context.l10n.scratchPlay,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.themeColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: widget.themeColor.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
