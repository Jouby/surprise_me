import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/text_formatters.dart';
import '../../../unlock/presentation/providers/unlock_provider.dart';
import '../providers/surprise_provider.dart';
import '../widgets/surprise_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dernier code de join traité — évite d'ouvrir la sheet plusieurs fois
  // pour le même deep link.
  String? _lastHandledJoinCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Charge les codes au premier affichage puis à chaque mise à jour.
      final surpriseProvider = context.read<SurpriseProvider>();
      surpriseProvider.addListener(_onSurprisesChanged);
      _loadUnlockCodesForJoined();
    });
  }

  @override
  void dispose() {
    // Retire le listener proprement pour éviter les fuites mémoire.
    // On lit le provider via le contexte avant qu'il soit détaché.
    try {
      context.read<SurpriseProvider>().removeListener(_onSurprisesChanged);
    } catch (_) {}
    super.dispose();
  }

  void _onSurprisesChanged() => _loadUnlockCodesForJoined();

  void _loadUnlockCodesForJoined() {
    if (!mounted) return;
    final surprises = context.read<SurpriseProvider>().joinedSurprises;
    final unlock = context.read<UnlockProvider>();
    for (final s in surprises) {
      unlock.loadCodesForSurprise(s.id);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final joinCode = GoRouterState.of(context).uri.queryParameters['joinCode'];
    if (joinCode != null && joinCode != _lastHandledJoinCode) {
      _lastHandledJoinCode = joinCode;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showJoinSheet(initialCode: joinCode);
      });
    }
  }

  void _showJoinSheet({String? initialCode}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JoinSheet(
        initialCode: initialCode,
        onJoin: (code) async {
          final provider = context.read<SurpriseProvider>();
          final surprise = await provider.joinByShareCode(code);
          if (!context.mounted) return false;
          if (surprise == null) return false;
          // Ferme la sheet puis navigue vers le détail.
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          context.push(
            '/surprise/${surprise.id}',
            extra: SurpriseRouteArgs(surprise: surprise),
          );
          return true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Consumer<SurpriseProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context, provider),
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryLight,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else if (provider.error != null)
                SliverFillRemaining(child: _buildError(context, provider))
              else if (provider.surprises.isEmpty)
                SliverFillRemaining(child: _buildEmpty(context))
              else ...[
                if (provider.createdSurprises.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      icon: Icons.edit_rounded,
                      label: context.l10n.myCreations,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final s = provider.createdSurprises[index];
                      return SurpriseCard(
                        surprise: s,
                        isOwner: true,
                        onTap: () => context.push(
                          '/surprise/${s.id}',
                          extra: SurpriseRouteArgs(surprise: s, isOwner: true),
                        ),
                      );
                    }, childCount: provider.createdSurprises.length),
                  ),
                ],
                if (provider.joinedSurprises.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      icon: Icons.celebration_outlined,
                      label: context.l10n.joinedSurprises,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final s = provider.joinedSurprises[index];
                      return SurpriseCard(
                        surprise: s,
                        isOwner: false,
                        onTap: () => context.push(
                          '/surprise/${s.id}',
                          extra: SurpriseRouteArgs(surprise: s),
                        ),
                      );
                    }, childCount: provider.joinedSurprises.length),
                  ),
                ],
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 80 + MediaQuery.of(context).padding.bottom,
                  ),
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar(BuildContext context, SurpriseProvider provider) {
    return SliverAppBar(
      expandedHeight: 150,
      pinned: true,
      backgroundColor: AppTheme.surface,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: provider.isLoading ? null : provider.load,
          icon: const Icon(Icons.refresh_rounded, color: AppTheme.textMid),
          tooltip: context.l10n.refresh,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textMid),
            tooltip: context.l10n.settings,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        title: Text(
          context.l10n.yourSurprises,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 26,
            color: AppTheme.textDark,
          ),
        ),
        background: const ColoredBox(color: AppTheme.surface),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎁', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              context.l10n.noSurpriseYet,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textMid),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.noSurpriseHint,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, SurpriseProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 40,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.loadError,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppTheme.textMid),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.load,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _FabButton(
              label: context.l10n.join,
              icon: Icons.qr_code_scanner_rounded,
              onTap: () => _showJoinSheet(),
              outlined: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FabButton(
              label: context.l10n.create,
              icon: Icons.add_rounded,
              onTap: () => context.push('/create'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Fab button ───────────────────────────────────────────────────────────────

class _FabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;

  const _FabButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primary,
          side: const BorderSide(color: AppTheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: AppTheme.cardBg,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }
}

// ─── Section header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
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

// ─── Join sheet ───────────────────────────────────────────────────────────────

class _JoinSheet extends StatefulWidget {
  final Future<bool> Function(String code) onJoin;
  final String? initialCode;

  const _JoinSheet({required this.onJoin, this.initialCode});

  @override
  State<_JoinSheet> createState() => _JoinSheetState();
}

class _JoinSheetState extends State<_JoinSheet> {
  late final TextEditingController _controller;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode ?? '');
    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _submit());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final success = await widget.onJoin(_controller.text.trim());
    if (mounted && !success) {
      setState(() {
        _loading = false;
        _error = context.l10n.codeNotFound;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
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
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration_outlined,
              size: 28,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.joinSurpriseTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.enterSharedCode,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              UpperCaseTextFormatter(),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 6,
              color: AppTheme.primary,
            ),
            decoration: InputDecoration(
              hintText: 'XXXXXX',
              hintStyle: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
                letterSpacing: 6,
                color: AppTheme.textLight.withValues(alpha: 0.5),
              ),
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 15,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 6),
                Text(
                  _error!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(context.l10n.join),
            ),
          ),
        ],
      ),
    );
  }
}
