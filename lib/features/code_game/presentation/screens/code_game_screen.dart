import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/code_game_state.dart';

/// Écran plein écran du jeu Code Secret (Mastermind simplifié).
class CodeGameScreen extends StatefulWidget {
  final String code;
  final Color themeColor;

  const CodeGameScreen({
    super.key,
    required this.code,
    required this.themeColor,
  });

  @override
  State<CodeGameScreen> createState() => _CodeGameScreenState();
}

class _CodeGameScreenState extends State<CodeGameScreen> {
  late CodeGameState _state;

  @override
  void initState() {
    super.initState();
    _state = CodeGameState.initial(widget.code);
  }

  void _addDigit(String d) => setState(() => _state = _state.addDigit(d));
  void _delete() => setState(() => _state = _state.removeDigit());

  void _submit() {
    if (_state.currentInput.length != CodeGameState.codeLength) return;
    HapticFeedback.lightImpact();
    setState(() => _state = _state.submitGuess());
    // Notifie la page appelante si le code vient d'être trouvé.
    if (_state.isWon) Navigator.pop(context, true);
  }

  void _restart() =>
      setState(() => _state = CodeGameState.initial(widget.code));

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
          context.l10n.elementTypeCodeGame,
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
            tooltip: context.l10n.codeGameRestart,
            onPressed: _restart,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Compteur de tentatives
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                context.l10n.codeGameAttemptsLeft(
                  CodeGameState.maxAttempts - _state.guesses.length,
                ),
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Grille des tentatives
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ...List.generate(CodeGameState.maxAttempts, _buildRow),
                    if (_state.isOver) ...[
                      const SizedBox(height: 16),
                      _buildResultBanner(),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // Pavé numérique
            if (!_state.isOver) _buildNumpad(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ── Ligne de la grille ────────────────────────────────────────────────────

  Widget _buildRow(int rowIndex) {
    final isSubmitted = rowIndex < _state.guesses.length;
    final isCurrent = rowIndex == _state.guesses.length && !_state.isOver;
    final digits = isSubmitted
        ? _state.guesses[rowIndex].digits
        : isCurrent
        ? _state.currentInput
        : '';
    final results = isSubmitted ? _state.guesses[rowIndex].results : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cases des chiffres
          ...List.generate(CodeGameState.codeLength, (col) {
            final digit = col < digits.length ? digits[col] : null;
            final result = results?[col];
            return _buildDigitCell(
              digit: digit,
              result: result,
              isCurrent: isCurrent,
            );
          }),
          const SizedBox(width: 16),
          // Indicateurs de résultat (pegs)
          if (isSubmitted) _buildPegs(results!) else const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildDigitCell({
    required String? digit,
    required PegResult? result,
    required bool isCurrent,
  }) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    if (result == PegResult.correct) {
      bgColor = widget.themeColor;
      borderColor = widget.themeColor;
      textColor = Colors.white;
    } else if (result == PegResult.present) {
      bgColor = Colors.amber.shade100;
      borderColor = Colors.amber.shade400;
      textColor = Colors.amber.shade800;
    } else if (result == PegResult.absent) {
      bgColor = AppTheme.surface;
      borderColor = AppTheme.divider;
      textColor = AppTheme.textLight;
    } else if (isCurrent && digit != null) {
      bgColor = widget.themeColor.withValues(alpha: 0.08);
      borderColor = widget.themeColor.withValues(alpha: 0.6);
      textColor = widget.themeColor;
    } else {
      bgColor = AppTheme.surface;
      borderColor = AppTheme.divider;
      textColor = AppTheme.textMid;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: digit != null
          ? Text(
              digit,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            )
          : null,
    );
  }

  /// 4 petits cercles colorés indiquant les résultats de la tentative.
  Widget _buildPegs(List<PegResult> results) {
    // Trie : corrects en premier, puis présents, puis absents (comme Mastermind).
    final sorted = [...results]
      ..sort((a, b) {
        const order = [PegResult.correct, PegResult.present, PegResult.absent];
        return order.indexOf(a).compareTo(order.indexOf(b));
      });

    return SizedBox(
      width: 48,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: sorted.map((r) {
          Color color;
          if (r == PegResult.correct) {
            color = widget.themeColor;
          } else if (r == PegResult.present) {
            color = Colors.amber.shade400;
          } else {
            color = AppTheme.divider;
          }
          return Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          );
        }).toList(),
      ),
    );
  }

  // ── Bannière résultat ─────────────────────────────────────────────────────

  Widget _buildResultBanner() {
    final won = _state.isWon;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
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
                won ? Icons.lock_open_rounded : Icons.lock_rounded,
                color: won ? Colors.green.shade600 : Colors.red.shade400,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  won
                      ? context.l10n.codeGameWon
                      : context.l10n.codeGameLost(widget.code),
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
            onPressed: _restart,
            icon: Icon(
              Icons.refresh_rounded,
              size: 16,
              color: won ? Colors.green.shade600 : Colors.red.shade400,
            ),
            label: Text(
              context.l10n.codeGameRestart,
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

  // ── Pavé numérique ────────────────────────────────────────────────────────

  Widget _buildNumpad() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      color: AppTheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ligne 1–3 / 4–6 / 7–9
          for (final row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row
                    .map(
                      (d) => _NumpadKey(
                        label: d,
                        onTap: () => _addDigit(d),
                        themeColor: widget.themeColor,
                      ),
                    )
                    .toList(),
              ),
            ),
          // Dernière ligne : effacer / 0 / valider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NumpadKey(
                label: '⌫',
                isAction: true,
                onTap: _delete,
                themeColor: widget.themeColor,
              ),
              _NumpadKey(
                label: '0',
                onTap: () => _addDigit('0'),
                themeColor: widget.themeColor,
              ),
              _NumpadKey(
                label: context.l10n.codeGameValidate,
                isAction: true,
                isWide: true,
                enabled: _state.currentInput.length == CodeGameState.codeLength,
                onTap: _submit,
                themeColor: widget.themeColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ── Touche du pavé numérique ──────────────────────────────────────────────────

class _NumpadKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color themeColor;
  final bool isAction;
  final bool isWide;
  final bool enabled;

  const _NumpadKey({
    required this.label,
    required this.onTap,
    required this.themeColor,
    this.isAction = false,
    this.isWide = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (isAction) {
      bgColor = enabled ? themeColor.withValues(alpha: 0.12) : AppTheme.surface;
      textColor = enabled ? themeColor : AppTheme.textLight;
    } else {
      bgColor = AppTheme.cardBg;
      textColor = AppTheme.textDark;
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: isWide ? 80 : 64,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
          boxShadow: isAction
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isWide ? 12 : 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
