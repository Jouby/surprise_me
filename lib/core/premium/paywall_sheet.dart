import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../utils/error_utils.dart';
import 'premium_provider.dart';

class PaywallSheet extends StatefulWidget {
  const PaywallSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<PremiumProvider>(),
        child: const PaywallSheet(),
      ),
    );
    return result ?? false;
  }

  @override
  State<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<PaywallSheet> {
  bool _loading = false;
  bool _restoring = false;
  String? _error;

  Future<void> _purchase() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final success = await context.read<PremiumProvider>().purchase();
      if (!mounted) return;
      if (success) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e, context));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _restoring = true;
      _error = null;
    });
    try {
      final success = await context.read<PremiumProvider>().restore();
      if (!mounted) return;
      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() => _error = context.l10n.premiumRestoreNotFound);
      }
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e, context));
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
            ),
            child: const Text('✨', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.premiumTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _Perk(
            icon: Icons.all_inclusive_rounded,
            text: context.l10n.premiumPerkUnlimited,
          ),
          const SizedBox(height: 12),
          _Perk(
            icon: Icons.sports_esports_rounded,
            text: context.l10n.premiumPerkGames,
          ),
          const SizedBox(height: 8),
          _Perk(
            icon: Icons.shopping_bag_outlined,
            text: context.l10n.premiumPerkOneTime,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 15,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _error!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Consumer<PremiumProvider>(
              builder: (context, premium, _) => ElevatedButton(
                onPressed: _loading ? null : _purchase,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        premium.priceString != null
                            ? '${context.l10n.premiumBuy} — ${premium.priceString}'
                            : context.l10n.premiumBuy,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _restoring ? null : _restore,
            child: _restoring
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    context.l10n.premiumRestore,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 13,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Perk({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryLight),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppTheme.textMid),
          ),
        ),
      ],
    );
  }
}
