import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../domain/entities/puzzle_game_state.dart';
import '../../../../core/theme/app_theme.dart';

/// Renders the sliding-tile puzzle (taquin) for a given image URL.
///
/// The image is decoded once into a [ui.Image], then each tile paints its
/// exact 1/9th crop via [Canvas.drawImageRect] — no repeated network loads.
class PuzzleGameTile extends StatefulWidget {
  final String imageUrl;
  final Color themeColor;
  final VoidCallback? onSolved;

  const PuzzleGameTile({
    super.key,
    required this.imageUrl,
    this.themeColor = AppTheme.primaryLight,
    this.onSolved,
  });

  @override
  State<PuzzleGameTile> createState() => _PuzzleGameTileState();
}

class _PuzzleGameTileState extends State<PuzzleGameTile>
    with SingleTickerProviderStateMixin {
  late PuzzleGameState _state;
  late AnimationController _successCtrl;
  late Animation<double> _successAnim;

  ui.Image? _image;
  bool _imageError = false;

  static const double _gridSize = 252; // divisible by 3 → 84px per tile
  static const int _n = PuzzleGameState.gridSize;

  @override
  void initState() {
    super.initState();
    _state = PuzzleGameState.initial();
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successAnim = CurvedAnimation(
      parent: _successCtrl,
      curve: Curves.elasticOut,
    );
    _loadImage();
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    _image?.dispose();
    super.dispose();
  }

  // ── Image loading ─────────────────────────────────────────────────────────

  void _loadImage() {
    final provider = NetworkImage(widget.imageUrl);
    final stream = provider.resolve(ImageConfiguration.empty);
    stream.addListener(
      ImageStreamListener(
        (info, _) {
          if (!mounted) return;
          setState(() => _image = info.image);
        },
        onError: (_, __) {
          if (!mounted) return;
          setState(() => _imageError = true);
        },
      ),
    );
  }

  // ── Interaction ───────────────────────────────────────────────────────────

  void _tap(int pos) {
    if (_state.tiles[pos] == PuzzleGameState.blankTile) return;
    if (!_state.canSlide(pos)) return;
    setState(() => _state = _state.slide(pos));
    if (_state.isSolved) {
      _successCtrl.forward(from: 0);
      widget.onSolved?.call();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildGrid(),
          const SizedBox(height: 12),
          if (_state.isSolved) _buildSuccessBanner() else _buildResetButton(),
        ],
      ),
    );
  }

  // ── Grid ──────────────────────────────────────────────────────────────────

  Widget _buildGrid() {
    return Container(
      width: _gridSize,
      height: _gridSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _state.isSolved
              ? Colors.green.shade300
              : widget.themeColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: _imageError
          ? _buildErrorPlaceholder()
          : _image == null
          ? _buildLoadingPlaceholder()
          : _buildTileGrid(),
    );
  }

  Widget _buildTileGrid() {
    const gap = 2.0;
    // Integer tile size to avoid float accumulation across 3 tiles + 2 gaps.
    final tileSize = (_gridSize - gap * (_n - 1)) / _n;

    return SizedBox(
      width: _gridSize,
      height: _gridSize,
      child: Stack(
        children: List.generate(_n * _n, (pos) {
          final row = pos ~/ _n;
          final col = pos % _n;
          final dx = col * (tileSize + gap);
          final dy = row * (tileSize + gap);
          final tileId = _state.tiles[pos];
          final isBlank = tileId == PuzzleGameState.blankTile;
          final canSlide = !isBlank && _state.canSlide(pos);

          return Positioned(
            left: dx,
            top: dy,
            width: tileSize,
            height: tileSize,
            child: GestureDetector(
              onTap: () => _tap(pos),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  color: isBlank ? AppTheme.surface : null,
                  border: isBlank
                      ? Border.all(color: AppTheme.divider, width: 0.5)
                      : null,
                ),
                child: isBlank
                    ? null
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomPaint(
                            painter: _TilePainter(
                              image: _image!,
                              tileId: tileId,
                              gridN: _n,
                            ),
                          ),
                          if (canSlide && !_state.isSolved)
                            Container(
                              color: widget.themeColor.withValues(alpha: 0.15),
                            ),
                        ],
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Center(
      child: CircularProgressIndicator(
        color: widget.themeColor,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: AppTheme.textLight,
            size: 32,
          ),
          const SizedBox(height: 6),
          Text(
            'Image introuvable',
            style: TextStyle(fontSize: 12, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }

  // ── Success banner ────────────────────────────────────────────────────────

  Widget _buildSuccessBanner() {
    return ScaleTransition(
      scale: _successAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: Colors.green.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              'Bravo ! Puzzle reconstitué !',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reset button ──────────────────────────────────────────────────────────

  Widget _buildResetButton() {
    return TextButton.icon(
      onPressed: () {
        _successCtrl.reset();
        setState(() => _state = _state.reset());
      },
      icon: Icon(Icons.shuffle_rounded, size: 14, color: AppTheme.textLight),
      label: Text(
        'Mélanger à nouveau',
        style: TextStyle(fontSize: 12, color: AppTheme.textLight),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ── Tile painter ──────────────────────────────────────────────────────────────

/// Paints the exact crop of [image] that corresponds to [tileId]
/// in a [gridN]×[gridN] grid using [Canvas.drawImageRect].
class _TilePainter extends CustomPainter {
  final ui.Image image;
  final int tileId;
  final int gridN;

  const _TilePainter({
    required this.image,
    required this.tileId,
    required this.gridN,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final col = tileId % gridN;
    final row = tileId ~/ gridN;

    final tileW = image.width / gridN;
    final tileH = image.height / gridN;

    final src = Rect.fromLTWH(col * tileW, row * tileH, tileW, tileH);
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(_TilePainter old) =>
      old.image != image || old.tileId != tileId;
}
