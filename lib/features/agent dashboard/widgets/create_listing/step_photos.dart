import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/agent%20dashboard/notifier/create_listing_notifier.dart';
import 'package:find_homes/features/agent%20dashboard/notifier/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class StepPhotos extends ConsumerStatefulWidget {
  const StepPhotos({super.key});

  @override
  StepPhotosState createState() => StepPhotosState();
}

/// Public state so the parent screen can call [submit] via a GlobalKey.
class StepPhotosState extends ConsumerState<StepPhotos> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(createListingNotifierProvider);
    _images.addAll(draft.images);
  }

  // ── Image actions ───────────────────────────────────────────────────────

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  // ── Submit ──────────────────────────────────────────────────────────────

  /// Validates photos, persists them to the notifier, and submits the full
  /// listing to the backend. Called from the AppBar "Save" button.
  Future<void> submit() async {
    if (_images.isEmpty) {
      _showFlushbar(message: 'Please add at least one photo', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      ref
          .read(createListingNotifierProvider.notifier)
          .updateStep4(images: _images);
      await ref.read(createListingNotifierProvider.notifier).submit();

      if (mounted) {
        ref.invalidate(dashboardNotifierProvider);
        ref.read(createListingNotifierProvider.notifier).reset();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showFlushbar(
          message: BackendError.extractMessage(e),
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── Flushbar helper ─────────────────────────────────────────────────────

  void _showFlushbar({required String message, bool isError = false}) {
    Flushbar<void>(
      messageText: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.card),
      ),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: AppColors.card,
      ),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Text('Add Listing Photos', style: AppTypography.displayLarge),
              const SizedBox(height: 8),
              Text(
                'High-quality photos increase trust and inquiries. '
                'Minimum 5 photos required. First photo is your cover.',
                style: AppTypography.body.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 24),

              // ── Photo grid ──────────────────────────────────────────
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _images.length + 1, // +1 for "Add Photo" tile
                itemBuilder: (context, index) {
                  if (index < _images.length) {
                    return _buildPhotoTile(index);
                  }
                  return _buildAddPhotoTile();
                },
              ),
              const SizedBox(height: 24),

              // ── Info banner ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ensure photos are well-lit and show accurate '
                        'depictions of the property. Listings with verified, '
                        'high-quality photos receive 3x more inquiries.',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),

        // ── Submitting overlay ───────────────────────────────────────────
        if (_isSubmitting)
          Container(
            color: AppColors.card.withValues(alpha: .85),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Creating listing…',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── Photo tile ────────────────────────────────────────────────────────

  Widget _buildPhotoTile(int index) {
    final isCover = index == 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(_images[index], fit: BoxFit.cover),

          // Cover badge
          if (isCover)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '⭐ Cover Photo',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.card,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          // Delete button
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Add photo tile ──────────────────────────────────────────────────

  Widget _buildAddPhotoTile() {
    return GestureDetector(
      onTap: _isSubmitting ? null : _pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.divider,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined,
                color: AppColors.primary, size: 28),
            const SizedBox(height: 6),
            Text(
              'Add Photo',
              style:
                  AppTypography.caption.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
