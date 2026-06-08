import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';

/// Écran plein écran du jeu Gratte-moi.
/// [content] est soit un texte libre, soit une URL d'image (commence par http).
/// Retourne `true` via [Navigator.pop] quand le grattage est terminé.
class ScratchGameScreen extends StatefulWidget {
  final String content;
  final Color themeColor;

  const ScratchGameScreen({
    super.key,
    required this.content,
    required this.themeColor,
  });

  static bool isImageContent(String content) =>
      content.startsWith('http://') || content.startsWith('https://');

  /// Seuil de surface grattée pour déclencher la révélation complète (60 %).
  static const double revealThreshold = 0.60;

  @override
  State<ScratchGameScreen> createState() => _ScratchGameScreenState();
}

class _ScratchGameScreenState extends State<ScratchGameScreen>
    with SingleTickerProviderStateMixin {
  final List<Offset> _points = [];
  static const double _brushRadius = 28.0;
  static const int _gridRes = 50;

  bool _fullyRevealed = false;
  bool _poppingScheduled = false;

  late AnimationController _revealCtrl;
  late Animation<double> _revealAnim;

  Size _canvasSize = Size.zero;
  final Set<int> _scratchedCells = {};

  // Image préchargée si le contenu est une URL.
  ui.Image? _networkImage;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _revealAnim = CurvedAnimation(parent: _revealCtrl, curve: Curves.easeOut);

    if (ScratchGameScreen.isImageContent(widget.content)) {
      _loadNetworkImage();
    }
  }

  @override
  void dispose() {
    _revealCtrl.dispose();
    _networkImage?.dispose();
    super.dispose();
  }

  // ── Chargement image ──────────────────────────────────────────────────────

  void _loadNetworkImage() {
    final stream = NetworkImage(
      widget.content,
    ).resolve(ImageConfiguration.empty);
    stream.addListener(
      ImageStreamListener(
        (info, _) {
          if (!mounted) return;
          setState(() => _networkImage = info.image);
        },
        onError: (_, __) {
          if (!mounted) return;
          setState(() => _imageError = true);
        },
      ),
    );
  }

  // ── Gestion du toucher ────────────────────────────────────────────────────

  void _handlePanStart(DragStartDetails d) {
    if (_fullyRevealed) return;
    setState(() {
      _points.add(d.localPosition);
      _trackCell(d.localPosition);
    });
  }

  void _handlePanUpdate(DragUpdateDetails d) {
    if (_fullyRevealed) return;
    setState(() {
      _points.add(d.localPosition);
      _trackCell(d.localPosition);
    });
    _checkThreshold();
  }

  void _trackCell(Offset pos) {
    if (_canvasSize == Size.zero) return;
    final cellW = _canvasSize.width / _gridRes;
    final cellH = _canvasSize.height / _gridRes;
    final col = (pos.dx / cellW).floor().clamp(0, _gridRes - 1);
    final row = (pos.dy / cellH).floor().clamp(0, _gridRes - 1);
    final radiusCols = (_brushRadius / cellW).ceil();
    final radiusRows = (_brushRadius / cellH).ceil();
    for (int dr = -radiusRows; dr <= radiusRows; dr++) {
      for (int dc = -radiusCols; dc <= radiusCols; dc++) {
        final r = (row + dr).clamp(0, _gridRes - 1);
        final c = (col + dc).clamp(0, _gridRes - 1);
        _scratchedCells.add(r * _gridRes + c);
      }
    }
  }

  void _checkThreshold() {
    if (_fullyRevealed || _poppingScheduled) return;
    final ratio = _scratchedCells.length / (_gridRes * _gridRes);
    if (ratio >= ScratchGameScreen.revealThreshold) {
      setState(() => _fullyRevealed = true);
      _revealCtrl.forward();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: AppTheme.textDark,
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          context.l10n.elementTypeScratch,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              _buildHint(),
              const SizedBox(height: 16),
              _buildScratchArea(),
              const SizedBox(height: 20),
              _buildProgress(),
              const Spacer(),
              if (_fullyRevealed) _buildReturnButton(context),
              if (_fullyRevealed) const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ── Texte d'invite ────────────────────────────────────────────────────────

  Widget _buildHint() {
    return AnimatedOpacity(
      opacity: _fullyRevealed ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app_rounded, size: 16, color: AppTheme.textLight),
          const SizedBox(width: 6),
          Text(
            context.l10n.scratchHint,
            style: TextStyle(fontSize: 14, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  // ── Zone de grattage ──────────────────────────────────────────────────────

  Widget _buildScratchArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = ScratchGameScreen.isImageContent(widget.content)
            ? width * 0.75
            : 200.0;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_canvasSize != Size(width, height)) {
            setState(() => _canvasSize = Size(width, height));
          }
        });

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildRevealedContent(width, height),
                if (!_fullyRevealed)
                  GestureDetector(
                    onPanStart: _handlePanStart,
                    onPanUpdate: _handlePanUpdate,
                    child: CustomPaint(
                      painter: _ScratchPainter(
                        points: List.unmodifiable(_points),
                        brushRadius: _brushRadius,
                      ),
                      size: Size(width, height),
                    ),
                  ),
                if (_fullyRevealed)
                  AnimatedBuilder(
                    animation: _revealAnim,
                    builder: (_, __) => IgnorePointer(
                      child: Opacity(
                        opacity: (1 - _revealAnim.value).clamp(0.0, 1.0),
                        child: CustomPaint(
                          painter: _ScratchPainter(
                            points: const [],
                            brushRadius: 0,
                            fullyOpaque: true,
                          ),
                          size: Size(width, height),
                        ),
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

  Widget _buildRevealedContent(double width, double height) {
    final isImage = ScratchGameScreen.isImageContent(widget.content);

    if (isImage) {
      if (_imageError) {
        return _buildImageErrorPlaceholder();
      }
      if (_networkImage == null) {
        return Container(
          color: widget.themeColor.withValues(alpha: 0.08),
          child: Center(
            child: CircularProgressIndicator(
              color: widget.themeColor,
              strokeWidth: 2,
            ),
          ),
        );
      }
      return Image.network(
        widget.content,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImageErrorPlaceholder(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.themeColor.withValues(alpha: 0.08),
        border: Border.all(
          color: widget.themeColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Text(
        widget.content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: widget.themeColor,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: AppTheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: AppTheme.textLight,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              'Image introuvable',
              style: TextStyle(fontSize: 12, color: AppTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }

  // ── Barre de progression ──────────────────────────────────────────────────

  Widget _buildProgress() {
    final percent = (_scratchedCells.length / (_gridRes * _gridRes) * 100)
        .round()
        .clamp(0, 100);

    return AnimatedOpacity(
      opacity: _fullyRevealed ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(widget.themeColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.scratchProgress(percent),
            style: TextStyle(fontSize: 12, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  // ── Bouton retour ─────────────────────────────────────────────────────────

  Widget _buildReturnButton(BuildContext context) {
    return ScaleTransition(
      scale: _revealAnim,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() => _poppingScheduled = true);
          Navigator.pop(context, true);
        },
        icon: const Icon(Icons.celebration_rounded, size: 18),
        label: Text(context.l10n.scratchBackToSurprise),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// ── Painter du calque argenté ─────────────────────────────────────────────────

class _ScratchPainter extends CustomPainter {
  final List<Offset> points;
  final double brushRadius;
  final bool fullyOpaque;

  static const _overlayColor = Color(0xFFB0BEC5);
  static const _shimmerColor = Color(0xFFCFD8DC);
  static const _shimmerColor2 = Color(0xFF90A4AE);

  const _ScratchPainter({
    required this.points,
    required this.brushRadius,
    this.fullyOpaque = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    // Fond gris argenté
    canvas.drawRect(Offset.zero & size, Paint()..color = _overlayColor);

    // Rayures shimmer diagonales
    final shimmerPaint = Paint()
      ..color = _shimmerColor
      ..strokeWidth = 4;
    final shimmerPaint2 = Paint()
      ..color = _shimmerColor2
      ..strokeWidth = 1.5;
    const spacing = 14.0;
    final diag = math.sqrt(size.width * size.width + size.height * size.height);
    for (double x = -diag; x < diag + size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        shimmerPaint,
      );
      canvas.drawLine(
        Offset(x + spacing / 2, 0),
        Offset(x + spacing / 2 + size.height, size.height),
        shimmerPaint2,
      );
    }

    // Texte d'invite (avant tout grattage)
    if (points.isEmpty && !fullyOpaque) {
      final tp = TextPainter(
        text: const TextSpan(
          text: '🪙  Gratte ici !',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF546E7A),
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
    }

    // Effacement des zones grattées
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
