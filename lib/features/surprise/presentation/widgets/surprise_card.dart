import 'package:flutter/material.dart';
import '../../domain/entities/surprise.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';

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
                    const SizedBox(height: 4),
                    Text(
                      surprise.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textLight,
                            fontSize: 13,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
