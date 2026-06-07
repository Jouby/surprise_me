import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/l10n.dart';

import '../../domain/usecases/upload_image_usecase.dart';
import '../../../../core/theme/app_theme.dart';

class ImagePickerField extends StatefulWidget {
  final ValueChanged<String?> onUploaded;
  final String? initialUrl;

  const ImagePickerField({
    super.key,
    required this.onUploaded,
    this.initialUrl,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  File? _file;
  bool _uploading = false;
  String? _error;
  String? _existingUrl; // URL déjà uploadée (mode édition)

  @override
  void initState() {
    super.initState();
    _existingUrl = widget.initialUrl;
  }

  Future<void> _pick(ImageSource source) async {
    // Résolution du use case avant tout await
    final uploadImage = context.read<UploadImageUseCase>();

    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (xfile == null) return;

    final file = File(xfile.path);
    setState(() {
      _file = file;
      _uploading = true;
      _error = null;
    });
    widget.onUploaded(null);

    final uploadErrorMsg = context.l10n.uploadError;
    try {
      final url = await uploadImage(file);
      widget.onUploaded(url);
      setState(() => _uploading = false);
    } catch (e) {
      debugPrint('❌ uploadImage error: $e');
      setState(() {
        _uploading = false;
        _error = uploadErrorMsg;
        _file = null;
      });
      widget.onUploaded(null);
    }
  }

  void _showSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.addImage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library_outlined,
                    label: context.l10n.gallery,
                    onTap: () {
                      Navigator.pop(context);
                      _pick(ImageSource.gallery);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    icon: Icons.camera_alt_outlined,
                    label: context.l10n.camera,
                    onTap: () {
                      Navigator.pop(context);
                      _pick(ImageSource.camera);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_file != null || _uploading) return _buildPreview();
    if (_existingUrl != null) return _buildExistingPreview();
    return _buildEmpty();
  }

  Widget _buildExistingPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            _existingUrl!,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildEmpty(),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              setState(() => _existingUrl = null);
              widget.onUploaded(null);
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: _showSourcePicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.change,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return GestureDetector(
      onTap: _showSourcePicker,
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.divider,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: AppTheme.primaryLight,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.galleryOrCamera,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryLight,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 6),
              Text(
                _error!,
                style: const TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            _file!,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        if (_uploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.uploading,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (!_uploading)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() => _file = null);
                widget.onUploaded(null);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (!_uploading)
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: _showSourcePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.change,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppTheme.primaryLight),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
