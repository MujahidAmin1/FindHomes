import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/property_extensions.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

class PropertySpecsRow extends StatelessWidget {
  final PropertyModel property;

  const PropertySpecsRow({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Divider(color: AppColors.surface, thickness: 2),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpecItem(Icons.bed_outlined, '${property.bedrooms ?? 0} Beds'),
              _buildDivider(),
              _buildSpecItem(Icons.bathtub_outlined, '${property.bathrooms ?? 0} Baths'),
              _buildDivider(),
              _buildSpecItem(Icons.square_foot, '${property.sizeSqm?.toStringAsFixed(0) ?? 0} Sqm'),
              _buildDivider(),
              _buildSpecItem(Icons.domain, property.propertyType.shortLabel),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.surface, thickness: 2),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.muted),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.5,
      height: 16,
      color: AppColors.divider,
    );
  }

}
