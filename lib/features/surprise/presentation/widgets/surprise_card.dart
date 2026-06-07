import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/surprise.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../unlock/presentation/providers/unlock_provider.dart';
import '../../../../core/l10n/l10n.dart';

class SurpriseCard extends StatelessWidget {
  final Surprise surprise;
  final VoidCallback onTap;
  final bool isOwner;

  const SurpriseCard({
    super.key,
    required this.surprise,
    required this.onTap,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = ColorUtils.fromHex(surprise.color);
    final colorLight = color.withValues(alpha: 0.1);
    final colorBorder = color.withValues(alpha: 0.25);

    final total = surprise.elements.length;
    final unlockProvider = context.watch<UnlockProvider>();
    final unlocked = isOwner
        ? total
        : surprise.elements
              .where(
                (e) => unlockProvider.isUnlocked(surprise.id, e.unlockCode),
              )
              .length;
    final showProgress = !isOwner && total > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorBorder),
                ),
                child: Center(
                  child: Text(
                    surprise.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surprise.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textDark,
                        fontSize: 17,
                      ),
                    ),
                    if (showProgress) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: unlocked / total,
                          minHeight: 4,
                          backgroundColor: AppTheme.divider,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${context.l10n.revealedElements} $unlocked / $total',
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorBorder),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
