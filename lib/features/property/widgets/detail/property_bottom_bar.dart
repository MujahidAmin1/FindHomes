import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';

import 'package:find_homes/core/utils/property_extensions.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

class PropertyBottomBar extends StatelessWidget {
  final PropertyModel property;

  const PropertyBottomBar({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    // Add safe area at the bottom for devices with home indicators
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL PRICE',
                style: AppTypography.caption.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                property.formattedPrice,
                style: AppTypography.titleMedium.copyWith(fontSize: 22),
              ),
            ],
          ),

          SizedBox(
            width: 140,
            child: AppButton(
              label: 'Pay Now',
              onPressed: () {
                // Handle pay now logic
              },
            ),
          ),
        ],
      ),
    );
  }

}
