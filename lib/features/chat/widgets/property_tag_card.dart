import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/formatters.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

/// Instagram story-reply style property context card.
/// Attached above the first message to show which property the
/// conversation is about.
class PropertyTagCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback? onTap;

  const PropertyTagCard({
    super.key,
    required this.property,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryImage = property.images
        .where((img) => img.isPrimary)
        .firstOrNull
        ?.imageUrl;
    final fallbackImage =
        property.images.isNotEmpty ? property.images.first.imageUrl : null;
    final imageUrl = primaryImage ?? fallbackImage;

    final formattedPrice = AppFormatters.formatCurrency(
      property.price.toString(),
      property.currency,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Property thumbnail
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryLight,
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Icon(
                        Icons.home_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.home_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
            ),

            const SizedBox(width: 10),

            // Property info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    property.title,
                    style: AppTypography.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedPrice,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),

            // Chevron
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
