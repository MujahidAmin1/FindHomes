import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/property_extensions.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

class PropertyHeaderInfo extends StatelessWidget {
  final PropertyModel property;

  const PropertyHeaderInfo({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTag(property.listingType.badgeLabel, true),
              const SizedBox(width: 8),
              _buildTag(property.propertyType.label, false),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            property.formattedPrice,
            style: AppTypography.screenTitle.copyWith(
              color: AppColors.ink,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            property.title,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 20,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.muted, // You could also use a custom gold if needed
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  property.locationText,
                  style: AppTypography.body.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.ink : AppColors.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: isDark ? Colors.white : AppColors.ink,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

}
