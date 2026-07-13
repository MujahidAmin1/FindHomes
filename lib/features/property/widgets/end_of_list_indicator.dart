import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Tiny indicator shown at the bottom of the property list.
///
/// Shows a spinner while `isLoadingMore` is true,
/// or a "You've reached the end" message when `hasReachedEnd` is true.
class EndOfListIndicator extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasReachedEnd;

  const EndOfListIndicator({
    super.key,
    required this.isLoadingMore,
    required this.hasReachedEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (hasReachedEnd) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.divider)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "You've reached the end",
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.muted),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.divider)),
              ],
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
