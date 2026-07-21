import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class PropertyEmptyState extends StatelessWidget {
  final VoidCallback onClearFilters;

  const PropertyEmptyState({super.key, required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.muted.withValues(alpha: .5),
            ),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or check back later for new listings.',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton.outlined(
              label: 'Clear Filters',
              expand: false,
              onPressed: onClearFilters,
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const PropertyErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: AppColors.muted.withValues(alpha: .5),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            AppButton.outlined(
              label: 'Retry',
              expand: false,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
