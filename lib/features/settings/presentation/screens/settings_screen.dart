import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/premium/premium_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../surprise/presentation/providers/surprise_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _userToken;
  String? _appVersion;
  String? _buildNumber;
  bool _loading = true;
  bool _clearingData = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<SurpriseProvider>();

    final results = await Future.wait([
      provider.getUserToken(),
      PackageInfo.fromPlatform(),
    ]);

    if (mounted) {
      final info = results[1] as PackageInfo;
      setState(() {
        _userToken = results[0] as String?;
        _appVersion = info.version;
        _buildNumber = info.buildNumber;
        _loading = false;
      });
    }
  }

  Future<void> _clearLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.clearLocalDataTitle),
        content: Text(ctx.l10n.clearLocalDataContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              ctx.l10n.clearLocalDataConfirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _clearingData = true);
    await context.read<SurpriseProvider>().clearAllData();
    if (mounted) {
      setState(() => _clearingData = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.clearLocalDataDone),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  void _copyToken() {
    if (_userToken == null) return;
    Clipboard.setData(ClipboardData(text: _userToken!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.tokenCopied),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          if (_loading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryLight,
                  strokeWidth: 2,
                ),
              ),
            )
          else ...[
            // ── Section creator token ───────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionHeader(
                icon: Icons.key_rounded,
                label: context.l10n.creatorTokens,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  context.l10n.creatorTokensHint,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textLight,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _UserTokenCard(
                  token: _userToken,
                  onCopy: _userToken != null ? _copyToken : null,
                ),
              ),
            ),

            // ── Section données locales ─────────────────────────────────────
            SliverToBoxAdapter(
              child: _SectionHeader(
                icon: Icons.storage_rounded,
                label: context.l10n.localData,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  context.l10n.clearLocalDataHint,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textLight,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _clearingData ? null : _clearLocalData,
                    icon: _clearingData
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Icon(
                            Icons.delete_sweep_rounded,
                            size: 18,
                            color: Colors.red,
                          ),
                    label: Text(
                      context.l10n.clearLocalDataButton,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: Colors.red.withValues(alpha: 0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Section debug (uniquement en mode debug) ────────────────────
            if (kDebugMode) ...[
              SliverToBoxAdapter(
                child: _SectionHeader(
                  icon: Icons.bug_report_rounded,
                  label: 'Debug',
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Consumer<PremiumProvider>(
                    builder: (context, premium, _) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Mode Premium',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textDark,
                          ),
                        ),
                        subtitle: const Text(
                          'Override local — debug uniquement',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textLight,
                          ),
                        ),
                        value: premium.isPremium,
                        activeThumbColor: AppTheme.primary,
                        onChanged: (v) => premium.debugSetPremium(v),
                      ),
                    ),
                  ),
                ),
              ),
            ],

            if (_appVersion != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Text(
                    'v$_appVersion (build $_buildNumber)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40 + MediaQuery.of(context).padding.bottom,
                ),
              ),
          ],
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.surface,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.divider),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 16,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ),
      title: Text(
        context.l10n.settings,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontSize: 20),
      ),
      centerTitle: true,
    );
  }
}

// ─── User token card ──────────────────────────────────────────────────────────

class _UserTokenCard extends StatefulWidget {
  final String? token;
  final VoidCallback? onCopy;

  const _UserTokenCard({required this.token, this.onCopy});

  @override
  State<_UserTokenCard> createState() => _UserTokenCardState();
}

class _UserTokenCardState extends State<_UserTokenCard> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final hasToken = widget.token != null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Token value
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fingerprint_rounded,
                  size: 22,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: hasToken
                    ? Text(
                        _visible
                            ? widget.token!
                            : '${widget.token!.substring(0, 8)}••••••••••••••••••••••••••••',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: AppTheme.textMid,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : const Text(
                        '—',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textLight,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
              if (hasToken) ...[
                const SizedBox(width: 8),
                // Bouton afficher/masquer
                GestureDetector(
                  onTap: () => setState(() => _visible = !_visible),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Icon(
                      _visible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 16,
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Bouton copier
                GestureDetector(
                  onTap: widget.onCopy,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppTheme.textLight),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
