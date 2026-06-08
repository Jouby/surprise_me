import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../data/datasources/code_local_datasource.dart';
import '../../domain/entities/code_game_state.dart';

/// Widget affiché dans l'ElementTile pour le type Code Secret.
///
/// - Si le code n'a pas encore été trouvé : aperçu des cases masquées
///   + bouton pour lancer le jeu en plein écran.
/// - Si le code a été trouvé (état persisté) : affiche le code en clair
///   avec une bannière de succès.
class CodeGameTile extends StatefulWidget {
  final String elementId;
  final String code;
  final Color themeColor;

  const CodeGameTile({
    super.key,
    required this.elementId,
    required this.code,
    this.themeColor = AppTheme.primaryLight,
  });

  @override
  State<CodeGameTile> createState() => _CodeGameTileState();
}

class _CodeGameTileState extends State<CodeGameTile> {
  final _ds = CodeLocalDatasource();
  bool? _isSolved; // null = chargement en cours

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final solved = await _ds.isSolved(widget.elementId);
    if (mounted) setState(() => _isSolved = solved);
  }

  Future<void> _openGame() async {
    final won = await context.push<bool>(
      '/code-game',
      extra: CodeGameRouteArgs(
        elementId: widget.elementId,
        code: widget.code,
        themeColor: widget.themeColor,
      ),
    );
    if (won == true && mounted) {
      await _ds.markSolved(widget.elementId);
      setState(() => _isSolved = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: _isSolved == null
          ? _buildLoading()
          : _isSolved!
          ? _buildSolved(context)
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

  // ── Code révélé ───────────────────────────────────────────────────────────

  Widget _buildSolved(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cases du code révélé
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.code.split('').map((digit) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.themeColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.themeColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: widget.themeColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                digit,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_open_rounded,
              size: 13,
              color: Colors.green.shade500,
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.codeGameSolved,
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
        // Aperçu : cases masquées
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(CodeGameState.codeLength, (_) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.divider, width: 1.5),
              ),
              child: Icon(Icons.circle, size: 10, color: AppTheme.textLight),
            );
          }),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _openGame,
            icon: Icon(
              Icons.lock_open_rounded,
              size: 16,
              color: widget.themeColor,
            ),
            label: Text(
              context.l10n.codeGamePlay,
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
