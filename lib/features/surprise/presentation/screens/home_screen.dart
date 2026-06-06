import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/surprise_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/text_formatters.dart';
import '../widgets/surprise_card.dart';
import 'create_surprise_screen.dart';
import 'surprise_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showJoinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JoinSheet(
        // Retourne true = succès (sheet déjà fermée + navigation),
        //          false = code invalide (sheet reste ouverte, erreur inline).
        onJoin: (code) async {
          final provider = context.read<SurpriseProvider>();
          final surprise = await provider.joinByShareCode(code);
          if (!context.mounted) return false;
          if (surprise == null) return false;
          // 1. Fermer la sheet depuis le contexte home (avant le push)
          Navigator.pop(context);
          // 2. Naviguer vers le détail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SurpriseDetailScreen(surprise: surprise),
            ),
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
                      label: 'Mes créations',
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final s = provider.createdSurprises[index];
                        return SurpriseCard(
                          surprise: s,
                          isOwner: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurpriseDetailScreen(
                                surprise: s,
                                isOwner: true,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: provider.createdSurprises.length,
                    ),
                  ),
                ],
                if (provider.joinedSurprises.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      icon: Icons.celebration_outlined,
                      label: 'Rejointes',
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final s = provider.joinedSurprises[index];
                        return SurpriseCard(
                          surprise: s,
                          isOwner: false,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurpriseDetailScreen(surprise: s),
                            ),
                          ),
                        );
                      },
                      childCount: provider.joinedSurprises.length,
                    ),
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
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: provider.isLoading ? null : provider.load,
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.textMid),
            tooltip: 'Actualiser',
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        title: Text(
          'Vos Surprises',
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
              'Aucune surprise pour l\'instant',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppTheme.textMid),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Créez une surprise ou entrez\nun code pour en rejoindre une.',
              style: TextStyle(color: AppTheme.textLight, fontSize: 13, height: 1.5),
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
            const Icon(Icons.wifi_off_rounded, size: 40, color: AppTheme.textLight),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger les surprises',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textMid),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.load,
              child: const Text('Réessayer'),
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
              label: 'Rejoindre',
              icon: Icons.qr_code_scanner_rounded,
              onTap: () => _showJoinSheet(context),
              outlined: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FabButton(
              label: 'Créer',
              icon: Icons.add_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateSurpriseScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
  // Retourne true si le code est valide (la sheet est déjà fermée côté home).
  final Future<bool> Function(String code) onJoin;

  const _JoinSheet({required this.onJoin});

  @override
  State<_JoinSheet> createState() => _JoinSheetState();
}

class _JoinSheetState extends State<_JoinSheet> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _loading = true; _error = null; });
    final success = await widget.onJoin(_controller.text.trim());
    // Si succès, la sheet a été fermée par le callback — inutile d'agir ici.
    // Si échec, on reste ouvert et on affiche l'erreur.
    if (mounted && !success) {
      setState(() {
        _loading = false;
        _error = 'Code introuvable. Vérifiez et réessayez.';
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
            child: const Icon(Icons.celebration_outlined,
                size: 28, color: AppTheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Rejoindre une surprise',
            style:
                Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            'Entrez le code partagé par l\'organisateur.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textLight, fontSize: 14),
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
            onChanged: (_) { if (_error != null) setState(() => _error = null); },
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 15, color: Colors.red.shade400),
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
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Rejoindre'),
            ),
          ),
        ],
      ),
    );
  }
}
