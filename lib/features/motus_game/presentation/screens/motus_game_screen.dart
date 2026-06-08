import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/motus_game_state.dart';

/// Écran plein écran du jeu Motus.
/// Reçoit le mot à deviner et la couleur thème via les arguments de route.
class MotusGameScreen extends StatefulWidget {
  final String word;
  final Color themeColor;

  const MotusGameScreen({
    super.key,
    required this.word,
    required this.themeColor,
  });

  @override
  State<MotusGameScreen> createState() => _MotusGameScreenState();
}

class _MotusGameScreenState extends State<MotusGameScreen> {
  late MotusGameState _state;

  // Disposition AZERTY
  static const _rows = [
    ['A', 'Z', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['Q', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M'],
    ['W', 'X', 'C', 'V', 'B', 'N'],
  ];

  @override
  void initState() {
    super.initState();
    _state = MotusGameState.initial(widget.word);
  }

  void _onLetter(String letter) {
    setState(() => _state = _state.addLetter(letter));
  }

  void _onDelete() {
    setState(() => _state = _state.removeLetter());
  }

  void _onSubmit() {
    if (_state.currentInput.length != _state.wordLength) return;
    HapticFeedback.lightImpact();
    setState(() => _state = _state.submitGuess());
  }

  void _onRestart() {
    setState(() => _state = MotusGameState.initial(widget.word));
  }

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.motusTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: AppTheme.textLight,
            tooltip: context.l10n.motusRestart,
            onPressed: _onRestart,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final cellSize = _computeCellSize(availableWidth);
            final keySize = _computeKeySize(availableWidth);
            return Column(
              children: [
                // Indicateur de tentatives
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    context.l10n.motusAttemptsLeft(
                      MotusGameState.maxAttempts - _state.guesses.length,
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Grille
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(MotusGameState.maxAttempts, (row) {
                            return _buildRow(row, cellSize);
                          }),
                          if (_state.isOver) ...[
                            const SizedBox(height: 16),
                            _buildResultBanner(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                // Clavier
                if (!_state.isOver) _buildKeyboard(keySize),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Tailles adaptatives ───────────────────────────────────────────────────

  /// Taille d'une cellule de grille calculée pour ne jamais dépasser la largeur
  /// disponible (padding 32px + 6px de marge par cellule).
  double _computeCellSize(double availableWidth) {
    final preferred = _preferredCellSize;
    final maxByWidth =
        (availableWidth - 32 - _state.wordLength * 6) / _state.wordLength;
    return min(preferred, maxByWidth).clamp(20.0, 60.0);
  }

  double get _preferredCellSize {
    final len = _state.wordLength;
    if (len <= 5) return 52;
    if (len <= 7) return 44;
    if (len <= 9) return 36;
    return 30;
  }

  /// Largeur d'une touche du clavier calculée sur la rangée la plus large
  /// (10 touches) avec 6px de marge par touche et 16px de padding conteneur.
  double _computeKeySize(double availableWidth) {
    const longestRow = 10;
    const margin = 6.0; // 3px de chaque côté
    const containerPadding = 16.0; // 8px de chaque côté
    return ((availableWidth - containerPadding - longestRow * margin) /
            longestRow)
        .clamp(24.0, 40.0);
  }

  // ── Ligne de la grille ────────────────────────────────────────────────────

  Widget _buildRow(int rowIndex, double cellSize) {
    final isSubmitted = rowIndex < _state.guesses.length;
    final isCurrent = rowIndex == _state.guesses.length && !_state.isOver;
    final letters = isSubmitted
        ? _state.guesses[rowIndex].letters
        : isCurrent
        ? _state.currentInput
        : '';
    final results = isSubmitted ? _state.guesses[rowIndex].results : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_state.wordLength, (col) {
          final letter = col < letters.length ? letters[col] : null;
          final result = results != null ? results[col] : null;

          return _buildCell(
            letter: letter,
            result: result,
            isCurrent: isCurrent,
            isEmpty: letter == null,
            cellSize: cellSize,
          );
        }),
      ),
    );
  }

  Widget _buildCell({
    required String? letter,
    required TileResult? result,
    required bool isCurrent,
    required bool isEmpty,
    required double cellSize,
  }) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    if (result == TileResult.correct) {
      bgColor = widget.themeColor;
      borderColor = widget.themeColor;
      textColor = Colors.white;
    } else if (result == TileResult.present) {
      bgColor = Colors.amber.shade100;
      borderColor = Colors.amber.shade400;
      textColor = Colors.amber.shade800;
    } else if (result == TileResult.absent) {
      bgColor = AppTheme.surface;
      borderColor = AppTheme.divider;
      textColor = AppTheme.textLight;
    } else if (isCurrent && letter != null) {
      bgColor = widget.themeColor.withValues(alpha: 0.08);
      borderColor = widget.themeColor.withValues(alpha: 0.5);
      textColor = widget.themeColor;
    } else {
      bgColor = AppTheme.surface;
      borderColor = AppTheme.divider;
      textColor = AppTheme.textMid;
    }

    final size = cellSize;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: letter != null
          ? Text(
              letter,
              style: TextStyle(
                fontSize: size * 0.48,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            )
          : null,
    );
  }

  // ── Bannière résultat ─────────────────────────────────────────────────────

  Widget _buildResultBanner() {
    final won = _state.isWon;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: won ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: won ? Colors.green.shade300 : Colors.red.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                won
                    ? Icons.check_circle_rounded
                    : Icons.sentiment_dissatisfied_rounded,
                color: won ? Colors.green.shade600 : Colors.red.shade400,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  won
                      ? context.l10n.motusWon
                      : context.l10n.motusLost(widget.word),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: won ? Colors.green.shade700 : Colors.red.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _onRestart,
            icon: Icon(
              Icons.refresh_rounded,
              size: 16,
              color: won ? Colors.green.shade600 : Colors.red.shade400,
            ),
            label: Text(
              context.l10n.motusRestart,
              style: TextStyle(
                color: won ? Colors.green.shade700 : Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Clavier AZERTY ────────────────────────────────────────────────────────

  Widget _buildKeyboard(double keySize) {
    final used = _state.usedLetters;
    // La touche OK est légèrement plus large que deux touches normales.
    final wideKeySize = keySize * 2 + 6;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      color: AppTheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((letter) {
                  return _KeyboardKey(
                    letter: letter,
                    result: used[letter],
                    themeColor: widget.themeColor,
                    onTap: () => _onLetter(letter),
                    keyWidth: keySize,
                  );
                }).toList(),
              ),
            ),
          ),
          // Ligne du bas : effacement + validation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _KeyboardKey(
                letter: '⌫',
                isAction: true,
                themeColor: widget.themeColor,
                onTap: _onDelete,
                keyWidth: keySize,
              ),
              const SizedBox(width: 6),
              _KeyboardKey(
                letter: context.l10n.motusValidate,
                isAction: true,
                themeColor: widget.themeColor,
                onTap: _onSubmit,
                enabled: _state.currentInput.length == _state.wordLength,
                keyWidth: wideKeySize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Touche du clavier ─────────────────────────────────────────────────────────

class _KeyboardKey extends StatelessWidget {
  final String letter;
  final TileResult? result;
  final Color themeColor;
  final VoidCallback onTap;
  final bool isAction;
  final bool enabled;
  final double keyWidth;

  const _KeyboardKey({
    required this.letter,
    required this.themeColor,
    required this.onTap,
    required this.keyWidth,
    this.result,
    this.isAction = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (isAction) {
      bgColor = enabled ? themeColor.withValues(alpha: 0.15) : AppTheme.surface;
      textColor = enabled ? themeColor : AppTheme.textLight;
    } else if (result == TileResult.correct) {
      bgColor = themeColor;
      textColor = Colors.white;
    } else if (result == TileResult.present) {
      bgColor = Colors.amber.shade200;
      textColor = Colors.amber.shade900;
    } else if (result == TileResult.absent) {
      bgColor = AppTheme.divider;
      textColor = AppTheme.textLight;
    } else {
      bgColor = AppTheme.surface;
      textColor = AppTheme.textDark;
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: keyWidth,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: result != null && !isAction
                ? Colors.transparent
                : AppTheme.divider,
          ),
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontSize: keyWidth < 32 ? 11 : 14,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
