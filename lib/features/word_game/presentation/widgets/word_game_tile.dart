import 'package:flutter/material.dart';
import '../../domain/entities/word_game_state.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';

/// Renders the drag-and-drop word game inside an ElementTile.
///
/// [word]       – the target word (stored as element content).
/// [themeColor] – accent colour forwarded from the parent tile.
class WordGameTile extends StatefulWidget {
  final String word;
  final Color themeColor;
  final VoidCallback? onSolved;

  const WordGameTile({
    super.key,
    required this.word,
    this.themeColor = AppTheme.primaryLight,
    this.onSolved,
  });

  @override
  State<WordGameTile> createState() => _WordGameTileState();
}

class _WordGameTileState extends State<WordGameTile>
    with SingleTickerProviderStateMixin {
  late WordGameState _state;
  late AnimationController _successCtrl;
  late Animation<double> _successAnim;

  @override
  void initState() {
    super.initState();
    _state = WordGameState.initial(widget.word);
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successAnim = CurvedAnimation(
      parent: _successCtrl,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    super.dispose();
  }

  void _update(WordGameState next) {
    setState(() => _state = next);
    if (next.isSolved) {
      _successCtrl.forward(from: 0);
      widget.onSolved?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSlots(),
          const SizedBox(height: 16),
          _buildPool(),
          if (_state.isSolved) ...[
            const SizedBox(height: 14),
            _buildSuccessBanner(),
          ],
          if (!_state.isSolved) ...[
            const SizedBox(height: 10),
            _buildResetButton(),
          ],
        ],
      ),
    );
  }

  // ── Answer slots ─────────────────────────────────────────────────────────

  Widget _buildSlots() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: List.generate(_state.word.length, (i) {
        final letter = _state.slots[i];
        return DragTarget<_LetterData>(
          onWillAcceptWithDetails: (_) => true,
          onAcceptWithDetails: (details) {
            final data = details.data;
            _update(_state.place(data.poolIndex, i));
          },
          builder: (context, candidates, rejected) {
            final isHovered = candidates.isNotEmpty;
            return GestureDetector(
              onTap: letter != null ? () => _update(_state.recall(i)) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: _tileSize,
                height: _tileSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: letter != null
                      ? (_state.isSolved
                            ? Colors.green.shade50
                            : widget.themeColor.withValues(alpha: 0.1))
                      : isHovered
                      ? widget.themeColor.withValues(alpha: 0.18)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: letter != null
                        ? (_state.isSolved
                              ? Colors.green.shade400
                              : widget.themeColor)
                        : isHovered
                        ? widget.themeColor
                        : AppTheme.divider,
                    width: 1.5,
                  ),
                ),
                child: letter != null
                    ? Text(
                        letter,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _state.isSolved
                              ? Colors.green.shade700
                              : widget.themeColor,
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }

  // ── Letter pool ───────────────────────────────────────────────────────────

  Widget _buildPool() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: List.generate(_state.pool.length, (i) {
        final letter = _state.pool[i];
        if (letter == null) {
          return SizedBox(width: _tileSize, height: _tileSize);
        }
        return Draggable<_LetterData>(
          data: _LetterData(poolIndex: i, letter: letter),
          feedback: _LetterChip(
            letter: letter,
            color: widget.themeColor,
            size: _tileSize,
            shadow: true,
          ),
          childWhenDragging: _LetterChip(
            letter: letter,
            color: AppTheme.divider,
            size: _tileSize,
            faded: true,
          ),
          child: _LetterChip(
            letter: letter,
            color: widget.themeColor,
            size: _tileSize,
          ),
        );
      }),
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
              context.l10n.congratulations,
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
      onPressed: () => _update(_state.reset()),
      icon: Icon(Icons.refresh_rounded, size: 14, color: AppTheme.textLight),
      label: Text(
        context.l10n.shuffleAgain,
        style: TextStyle(fontSize: 12, color: AppTheme.textLight),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  double get _tileSize {
    final wordLen = _state.word.length;
    if (wordLen <= 6) return 42;
    if (wordLen <= 9) return 36;
    return 30;
  }
}

// ── Data transferred during drag ──────────────────────────────────────────────

class _LetterData {
  final int poolIndex;
  final String letter;
  const _LetterData({required this.poolIndex, required this.letter});
}

// ── Single letter chip ────────────────────────────────────────────────────────

class _LetterChip extends StatelessWidget {
  final String letter;
  final Color color;
  final double size;
  final bool faded;
  final bool shadow;

  const _LetterChip({
    required this.letter,
    required this.color,
    required this.size,
    this.faded = false,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: faded ? AppTheme.surface : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: faded ? AppTheme.divider : color, width: 1.5),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: size * 0.43,
          fontWeight: FontWeight.w700,
          color: faded ? AppTheme.textLight : color,
        ),
      ),
    );
  }
}
