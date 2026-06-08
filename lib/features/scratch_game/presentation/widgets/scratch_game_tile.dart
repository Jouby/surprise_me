import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';

/// Widget "Gratte-moi" affiché dans l'ElementTile.
///
/// Le message [message] est caché sous un calque argenté que le joueur gratte
/// avec le doigt. Quand [revealThreshold] % de la surface est découverte,
/// le calque disparaît complètement et le message s'affiche en plein.
class ScratchGameTile extends StatefulWidget {
  final String message;
  final Color themeColor;

  /// Pourcentage de surface à gratter pour déclencher la révélation complète.
  static const double revealThreshold = 0.55;

  const ScratchGameTile({
    super.key,
    required this.message,
    this.themeColor = AppTheme.primaryLight,
  });

  @override
  State<ScratchGameTile> createState() => _ScratchGameTileState();
}

class _ScratchGameTileState extends State<ScratchGameTile>
    with SingleTickerProviderStateMixin {
  // Points de grattage (en coordonnées locales du widget).
  final List<Offset> _points = [];
  // Rayon du pinceau de grattage.
  static const double _brushRadius = 22.0;
  // Taille de la grille utilisée pour estimer la surface grattée.
  static const int _gridRes = 40;

  bool _fullyRevealed = false;

  late AnimationController _revealCtrl;
  late Animation<double> _revealAnim;

  // Taille effective du canvas, connue après le premier layout.
  Size _canvasSize = Size.zero;
  // Ensemble des cellules de la grille touchées (pour estimer %).
  final Set<int> _scratchedCells = {};

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _revealAnim = CurvedAnimation(parent: _revealCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _revealCtrl.dispose();
    super.dispose();
  }

  // ── Gestion du toucher ────────────────────────────────────────────────────

  void _handlePanUpdate(DragUpdateDetails d) {
    if (_fullyRevealed) return;
    setState(() {
      _points.add(d.localPosition);
      _trackCell(d.localPosition);
    });
    _checkRevealThreshold();
  }

  void _handlePanStart(DragStartDetails d) {
    if (_fullyRevealed) return;
    setState(() {
      _points.add(d.localPosition);
      _trackCell(d.localPosition);
    });
  }

  void _trackCell(Offset pos) {
    if (_canvasSize == Size.zero) return;
    final col = (pos.dx / _canvasSize.width * _gridRes).floor();
    final row = (pos.dy / _canvasSize.height * _gridRes).floor();
    final cCol = col.clamp(0, _gridRes - 1);
    final cRow = row.clamp(0, _gridRes - 1);
    // Marque aussi les cellules voisines selon le rayon du pinceau.
    final cellW = _canvasSize.width / _gridRes;
    final cellH = _canvasSize.height / _gridRes;
    final radiusCols = (_brushRadius / cellW).ceil();
    final radiusRows = (_brushRadius / cellH).ceil();
    for (int dr = -radiusRows; dr <= radiusRows; dr++) {
      for (int dc = -radiusCols; dc <= radiusCols; dc++) {
        final r = (cRow + dr).clamp(0, _gridRes - 1);
        final c = (cCol + dc).clamp(0, _gridRes - 1);
        _scratchedCells.add(r * _gridRes + c);
      }
    }
  }

  void _checkRevealThreshold() {
    if (_fullyRevealed) return;
    final ratio = _scratchedCells.length / (_gridRes * _gridRes);
    if (ratio >= ScratchGameTile.revealThreshold) {
      setState(() => _fullyRevealed = true);
      _revealCtrl.forward();
    }
  }

  void _reset() {
    setState(() {
      _points.clear();
      _scratchedCells.clear();
      _fullyRevealed = false;
    });
    _revealCtrl.reset();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScratchArea(),
          const SizedBox(height: 10),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildScratchArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 110.0;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_canvasSize != Size(width, height)) {
            setState(() => _canvasSize = Size(width, height));
          }
        });

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Fond : message révélé ──────────────────────────────────
                _buildRevealedContent(),
                // ── Calque argenté grattable ───────────────────────────────
                if (!_fullyRevealed)
                  GestureDetector(
                    onPanStart: _handlePanStart,
                    onPanUpdate: _handlePanUpdate,
                    child: CustomPaint(
                      painter: _ScratchPainter(
                        points: List.unmodifiable(_points),
                        brushRadius: _brushRadius,
                        overlayColor: _overlayColor,
                        shimmerColor: _shimmerColor,
                      ),
                      size: Size(width, height),
                    ),
                  ),
                // ── Animation de disparition finale ────────────────────────
                if (_fullyRevealed)
                  AnimatedBuilder(
                    animation: _revealAnim,
                    builder: (_, __) => Opacity(
                      opacity: (1 - _revealAnim.value).clamp(0.0, 1.0),
                      child: CustomPaint(
                        painter: _ScratchPainter(
                          points: const [],
                          brushRadius: 0,
                          overlayColor: _overlayColor,
                          shimmerColor: _shimmerColor,
                          fullyOpaque: true,
                        ),
                        size: Size(width, height),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevealedContent() {
    return Container(
      decoration: BoxDecoration(
        color: widget.themeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.themeColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        widget.message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: widget.themeColor,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (_fullyRevealed && _revealAnim.isCompleted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: Colors.green.shade500,
          ),
          const SizedBox(width: 5),
          Text(
            context.l10n.scratchRevealed,
            style: TextStyle(
              fontSize: 12,
              color: Colors.green.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _reset,
            child: Text(
              context.l10n.scratchRestart,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textLight,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _revealAnim,
      builder: (_, __) {
        if (_fullyRevealed) return const SizedBox.shrink();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_rounded, size: 14, color: AppTheme.textLight),
            const SizedBox(width: 5),
            Text(
              _points.isEmpty
                  ? context.l10n.scratchHint
                  : context.l10n.scratchProgress(
                      (_scratchedCells.length / (_gridRes * _gridRes) * 100)
                          .round()
                          .clamp(0, 100),
                    ),
              style: TextStyle(fontSize: 12, color: AppTheme.textLight),
            ),
          ],
        );
      },
    );
  }

  Color get _overlayColor => const Color(0xFFB8C4CC);
  Color get _shimmerColor => const Color(0xFFD4DFE6);
}

// ── Painter du calque argenté ─────────────────────────────────────────────────

class _ScratchPainter extends CustomPainter {
  final List<Offset> points;
  final double brushRadius;
  final Color overlayColor;
  final Color shimmerColor;
  final bool fullyOpaque;

  const _ScratchPainter({
    required this.points,
    required this.brushRadius,
    required this.overlayColor,
    required this.shimmerColor,
    this.fullyOpaque = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // saveLayer indispensable pour que BlendMode.clear efface vraiment le calque.
    canvas.saveLayer(Offset.zero & size, Paint());

    // ── Fond argenté avec fines rayures diagonales (effet "grattage") ──────
    final bgPaint = Paint()..color = overlayColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Rayures shimmer
    final shimmerPaint = Paint()
      ..color = shimmerColor
      ..strokeWidth = 3;
    const spacing = 12.0;
    final diag = math.sqrt(size.width * size.width + size.height * size.height);
    for (double x = -diag; x < diag + size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        shimmerPaint,
      );
    }

    // Texte d'invite centré dans le calque (avant grattage)
    if (points.isEmpty && !fullyOpaque) {
      final tp = TextPainter(
        text: TextSpan(
          text: '🪙  Gratte ici !',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7B85),
            letterSpacing: 0.5,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
    }

    // ── Effacement des zones grattées ──────────────────────────────────────
    if (!fullyOpaque) {
      final erasePaint = Paint()
        ..blendMode = BlendMode.clear
        ..style = PaintingStyle.fill;

      for (final p in points) {
        canvas.drawCircle(p, brushRadius, erasePaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScratchPainter old) =>
      old.points.length != points.length || old.fullyOpaque != fullyOpaque;
}
