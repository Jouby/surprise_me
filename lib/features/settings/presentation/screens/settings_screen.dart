import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../surprise/domain/entities/surprise.dart';
import '../../../surprise/domain/repositories/i_surprise_repository.dart';
import '../../../surprise/presentation/providers/surprise_provider.dart';
import '../../../unlock/data/datasources/unlock_local_datasource.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Map surpriseId → creatorToken (null = pas de token sur cet appareil)
  Map<String, String?> _tokens = {};
  List<String> _savedShareCodes = [];
  int _unlockedCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = context.read<ISurpriseRepository>();
    final createdSurprises =
        context.read<SurpriseProvider>().createdSurprises;

    // Charge les tokens pour chaque surprise créée
    final tokens = <String, String?>{};
    for (final s in createdSurprises) {
      tokens[s.id] = await repo.getCreatorToken(s.id);
    }

    // Données locales générales
    final savedCodes = await repo.getSavedCodes();
    final unlockedDs = UnlockLocalDatasource();
    final unlockedCodes = await unlockedDs.loadCodes();

    if (mounted) {
      setState(() {
        _tokens = tokens;
        _savedShareCodes = savedCodes;
        _unlockedCount = unlockedCodes.length;
        _loading = false;
      });
    }
  }

  void _copyToken(String token) {
    Clipboard.setData(ClipboardData(text: token));
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
    final createdSurprises =
        context.watch<SurpriseProvider>().createdSurprises;

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
            // ── Section creator tokens ──────────────────────────────────────
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
            if (createdSurprises.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _EmptyCard(label: context.l10n.noCreatedSurprises),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final surprise = createdSurprises[index];
                    final token = _tokens[surprise.id];
                    return _TokenCard(
                      surprise: surprise,
                      token: token,
                      onCopy: token != null ? () => _copyToken(token) : null,
                    );
                  },
                  childCount: createdSurprises.length,
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
                  context.l10n.localDataHint,
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
                child: Column(
                  children: [
                    _DataRow(
                      icon: Icons.qr_code_rounded,
                      label: context.l10n.savedShareCodes,
                      value: _savedShareCodes.length.toString(),
                    ),
                    const SizedBox(height: 8),
                    _DataRow(
                      icon: Icons.lock_open_rounded,
                      label: context.l10n.unlockedCodes,
                      value: _unlockedCount.toString(),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                  height: 40 + MediaQuery.of(context).padding.bottom),
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
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.divider),
            ),
            child: const Icon(Icons.arrow_back_ios_rounded,
                size: 16, color: AppTheme.textDark),
          ),
        ),
      ),
      title: Text(
        context.l10n.settings,
        style:
            Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
      ),
      centerTitle: true,
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

// ─── Token card ───────────────────────────────────────────────────────────────

class _TokenCard extends StatefulWidget {
  final Surprise surprise;
  final String? token;
  final VoidCallback? onCopy;

  const _TokenCard({
    required this.surprise,
    required this.token,
    this.onCopy,
  });

  @override
  State<_TokenCard> createState() => _TokenCardState();
}

class _TokenCardState extends State<_TokenCard> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final themeColor = ColorUtils.fromHex(widget.surprise.color);
    final hasToken = widget.token != null;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : emoji + titre + code
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(widget.surprise.emoji,
                    style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.surprise.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.surpriseId(widget.surprise.id),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textLight,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: AppTheme.divider, height: 1),
          const SizedBox(height: 14),

          // Token row
          Row(
            children: [
              Expanded(
                child: hasToken
                    ? Text(
                        _visible
                            ? widget.token!
                            : '${widget.token!.substring(0, 8)}••••••••••••••••••••••••••••',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: AppTheme.textMid,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        '—',
                        style: const TextStyle(
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Icon(
                      _visible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 15,
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Bouton copier
                GestureDetector(
                  onTap: widget.onCopy,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: themeColor.withValues(alpha: 0.2)),
                    ),
                    child: Icon(Icons.copy_rounded,
                        size: 15, color: themeColor),
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

// ─── Data row ─────────────────────────────────────────────────────────────────

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textLight),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMid,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty card ───────────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: AppTheme.textLight,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
