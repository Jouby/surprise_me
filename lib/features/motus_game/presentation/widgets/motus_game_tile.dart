import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../data/datasources/motus_local_datasource.dart';

/// Widget affiché dans l'ElementTile pour le type Motus.
///
/// - Si le mot n'a pas encore été trouvé : aperçu des cases masquées
///   + bouton pour lancer le jeu en plein écran.
/// - Si le mot a été trouvé (état persisté) : affiche le mot lettre par lettre
///   avec les cases en couleur thème.
class MotusGameTile extends StatefulWidget {
  final String elementId;
  final String word;
  final Color themeColor;
  final VoidCallback? onSolved;

  const MotusGameTile({
    super.key,
    required this.elementId,
    required this.word,
    this.themeColor = AppTheme.primaryLight,
    this.onSolved,
  });

  @override
  State<MotusGameTile> createState() => _MotusGameTileState();
}

class _MotusGameTileState extends State<MotusGameTile> {
  final _ds = MotusLocalDatasource();
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
    final upper = widget.word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    final won = await context.push<bool>(
      '/motus',
      extra: MotusRouteArgs(
        elementId: widget.elementId,
        word: upper,
        themeColor: widget.themeColor,
      ),
    );
    if (won == true && mounted) {
      await _ds.markSolved(widget.elementId);
      setState(() => _isSolved = true);
      widget.onSolved?.call();
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

  // ── Mot révélé ────────────────────────────────────────────────────────────

  Widget _buildSolved(BuildContext context) {
    final upper = widget.word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    return LayoutBuilder(
      builder: (context, constraints) {
        final preferred = _preferredTileSize(upper.length);
        final maxByWidth =
            (constraints.maxWidth - upper.length * 6) / upper.length;
        final size = preferred.clamp(0.0, maxByWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: upper.split('').map((letter) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: size,
                  height: size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.themeColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: widget.themeColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: widget.themeColor.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: size * 0.48,
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
                  Icons.check_circle_rounded,
                  size: 13,
                  color: Colors.green.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  context.l10n.motusRevealed,
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
      },
    );
  }

  // ── Bouton jouer ──────────────────────────────────────────────────────────

  Widget _buildPlayButton(BuildContext context) {
    final upper = widget.word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    final length = upper.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final preferred = _preferredTileSize(length);
        final maxByWidth = (constraints.maxWidth - length * 6) / length;
        final size = preferred.clamp(0.0, maxByWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Aperçu : première lettre révélée, reste masqué
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(length, (i) {
                final isFirst = i == 0;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: size,
                  height: size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isFirst
                        ? widget.themeColor.withValues(alpha: 0.15)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isFirst ? widget.themeColor : AppTheme.divider,
                      width: 1.5,
                    ),
                  ),
                  child: isFirst
                      ? Text(
                          upper[0],
                          style: TextStyle(
                            fontSize: size * 0.48,
                            fontWeight: FontWeight.w800,
                            color: widget.themeColor,
                          ),
                        )
                      : null,
                );
              }),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openGame,
                icon: Icon(
                  Icons.play_arrow_rounded,
                  size: 18,
                  color: widget.themeColor,
                ),
                label: Text(
                  context.l10n.playMotus,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.themeColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: widget.themeColor.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _preferredTileSize(int len) {
    if (len <= 6) return 40;
    if (len <= 9) return 34;
    return 28;
  }
}
