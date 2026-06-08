import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';

/// Widget affiché dans l'ElementTile pour le type Motus.
/// Affiche un aperçu du nombre de lettres et un bouton pour lancer le jeu
/// en plein écran.
class MotusGameTile extends StatelessWidget {
  final String word;
  final Color themeColor;

  const MotusGameTile({
    super.key,
    required this.word,
    this.themeColor = AppTheme.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    final upper = word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    final length = upper.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Aperçu des cases (première lettre + cases vides)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(length, (i) {
              final isFirst = i == 0;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _tileSize(length),
                height: _tileSize(length),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFirst
                      ? themeColor.withValues(alpha: 0.15)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isFirst ? themeColor : AppTheme.divider,
                    width: 1.5,
                  ),
                ),
                child: isFirst
                    ? Text(
                        upper[0],
                        style: TextStyle(
                          fontSize: _tileSize(length) * 0.48,
                          fontWeight: FontWeight.w800,
                          color: themeColor,
                        ),
                      )
                    : null,
              );
            }),
          ),
          const SizedBox(height: 14),
          // Bouton jouer
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push(
                '/motus',
                extra: MotusRouteArgs(word: upper, themeColor: themeColor),
              ),
              icon: Icon(Icons.play_arrow_rounded, size: 18, color: themeColor),
              label: Text(
                context.l10n.playMotus,
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

  double _tileSize(int len) {
    if (len <= 6) return 40;
    if (len <= 9) return 34;
    return 28;
  }
}
