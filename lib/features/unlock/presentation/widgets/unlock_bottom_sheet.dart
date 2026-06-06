import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/unlock_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/text_formatters.dart';
import '../../../../core/l10n/l10n.dart';

class UnlockBottomSheet extends StatefulWidget {
  final UnlockProvider provider;
  final Color themeColor;

  const UnlockBottomSheet({
    super.key,
    required this.provider,
    this.themeColor = AppTheme.primary,
  });

  @override
  State<UnlockBottomSheet> createState() => _UnlockBottomSheetState();
}

class _UnlockBottomSheetState extends State<UnlockBottomSheet> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _feedback;
  bool _success = false;

  Color get _c => widget.themeColor;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _loading = true;
      _feedback = null;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    final ok = await widget.provider.tryUnlock(code);

    setState(() {
      _loading = false;
      _success = ok;
      _feedback = ok
          ? context.l10n.codeAccepted
          : context.l10n.invalidCode;
    });

    if (ok) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) Navigator.pop(context);
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
            decoration: BoxDecoration(
              color: _c.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.vpn_key_outlined, size: 28, color: _c),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.enterYourCode,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.codeUnlocksElement,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textLight,
                  fontSize: 14,
                ),
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 6,
              color: _c,
            ),
            decoration: InputDecoration(
              hintText: 'XXXXXX',
              hintStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                letterSpacing: 6,
                color: AppTheme.textLight.withValues(alpha: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _c, width: 2),
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          if (_feedback != null) ...[
            const SizedBox(height: 14),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _success
                    ? _c.withValues(alpha: 0.1)
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _success ? Icons.check_circle_outline : Icons.error_outline,
                    size: 16,
                    color: _success ? _c : Colors.red.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _feedback!,
                    style: TextStyle(
                      fontSize: 13,
                      color: _success ? _c : Colors.red.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: _c),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(context.l10n.unlock),
            ),
          ),
        ],
      ),
    );
  }
}
