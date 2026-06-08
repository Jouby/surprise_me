import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/code_game_state.dart';

/// Widget affiché dans l'ElementTile pour le type Code Secret.
/// Affiche un aperçu des cases masquées et un bouton pour lancer le jeu.
class CodeGameTile extends StatelessWidget {
  final String code;
  final Color themeColor;

  const CodeGameTile({
    super.key,
    required this.code,
    this.themeColor = AppTheme.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Aperçu : cases masquées représentant les 4 chiffres
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(CodeGameState.codeLength, (_) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
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
              onPressed: () => context.push(
                '/code-game',
                extra: CodeGameRouteArgs(code: code, themeColor: themeColor),
              ),
              icon: Icon(Icons.lock_open_rounded, size: 16, color: themeColor),
              label: Text(
                context.l10n.codeGamePlay,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: themeColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: themeColor.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
