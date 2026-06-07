import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/surprise_element.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../features/word_game/presentation/widgets/word_game_tile.dart';
import '../../../../features/puzzle_game/presentation/widgets/puzzle_game_tile.dart';

class ElementTile extends StatelessWidget {
  final SurpriseElement element;
  final bool isUnlocked;
  final bool ownerMode;
  final Color themeColor;

  const ElementTile({
    super.key,
    required this.element,
    required this.isUnlocked,
    this.ownerMode = false,
    this.themeColor = AppTheme.primaryLight,
  });

  bool get _revealed => isUnlocked || ownerMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _revealed
              ? themeColor.withValues(alpha: 0.4)
              : AppTheme.divider,
          width: _revealed ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: _revealed ? 0.08 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            _buildContent(context),
            if (!_revealed) _buildBlurOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildHeader(context), _buildBody(context)],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _revealed
                  ? themeColor.withValues(alpha: 0.12)
                  : AppTheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _iconForType(element.type),
              size: 16,
              color: _revealed ? themeColor : AppTheme.textLight,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            element.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _revealed ? themeColor : AppTheme.textLight,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
          const Spacer(),
          if (ownerMode)
            _UnlockCodeBadge(code: element.unlockCode, themeColor: themeColor)
          else if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_open_rounded, size: 11, color: themeColor),
                  const SizedBox(width: 3),
                  Text(
                    context.l10n.unlocked,
                    style: TextStyle(
                      fontSize: 10,
                      color: themeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (element.type == ElementType.image) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            element.content,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: AppTheme.surface,
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: AppTheme.textLight,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (element.type == ElementType.date) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Text(
          element.content,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    if (element.type == ElementType.location) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.place_outlined, size: 18, color: themeColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                element.content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textDark,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (element.type == ElementType.puzzle) {
      return PuzzleGameTile(imageUrl: element.content, themeColor: themeColor);
    }

    if (element.type == ElementType.wordGame) {
      return WordGameTile(word: element.content, themeColor: themeColor);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Text(
        element.content,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppTheme.textMid,
          fontSize: 14.5,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildBlurOverlay(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: AppTheme.blurOverlay.withValues(alpha: 0.75),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withValues(alpha: 0.15),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 22,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.enterCodeToReveal,
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(ElementType type) {
    switch (type) {
      case ElementType.text:
        return Icons.notes_rounded;
      case ElementType.image:
        return Icons.photo_outlined;
      case ElementType.date:
        return Icons.calendar_today_outlined;
      case ElementType.location:
        return Icons.place_outlined;
      case ElementType.wordGame:
        return Icons.casino_outlined;
      case ElementType.puzzle:
        return Icons.grid_view_rounded;
    }
  }
}

// ─── Badge code de déverrouillage (mode propriétaire) ────────────────────────

class _UnlockCodeBadge extends StatefulWidget {
  final String code;
  final Color themeColor;
  const _UnlockCodeBadge({required this.code, required this.themeColor});

  @override
  State<_UnlockCodeBadge> createState() => _UnlockCodeBadgeState();
}

class _UnlockCodeBadgeState extends State<_UnlockCodeBadge> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.themeColor;
    return GestureDetector(
      onTap: () => setState(() => _visible = !_visible),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _visible ? c.withValues(alpha: 0.12) : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _visible ? c : AppTheme.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _visible ? Icons.key_rounded : Icons.key_off_rounded,
              size: 11,
              color: _visible ? c : AppTheme.textLight,
            ),
            const SizedBox(width: 4),
            Text(
              _visible ? widget.code : '••••••',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: _visible ? 1.5 : 2,
                color: _visible ? c : AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
