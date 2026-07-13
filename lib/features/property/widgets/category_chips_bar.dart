import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

/// Horizontal row with scrollable category chips and a fixed filter button.
///
/// The filter button is pinned on the right, the chips scroll underneath it.
class CategoryChipsBar extends StatelessWidget {
  final PropertyType? selectedType;
  final ValueChanged<PropertyType?> onTypeSelected;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;

  const CategoryChipsBar({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.onFilterTap,
    this.hasActiveFilters = false,
  });

  static const _categories = <PropertyType?, String>{
    null: 'All',
    PropertyType.house: 'Houses',
    PropertyType.apartment: 'Apartments',
    PropertyType.land: 'Land',
    PropertyType.commercial: 'Commercial',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // ── Scrollable chips ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: _categories.entries.map((entry) {
                  final isSelected = selectedType == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (_) => onTypeSelected(entry.key),
                      labelStyle: AppTypography.caption.copyWith(
                        color: isSelected ? AppColors.card : AppColors.ink,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      backgroundColor: AppColors.card,
                      selectedColor: AppColors.primary,
                      side: BorderSide(
                        color:
                            isSelected ? AppColors.primary : AppColors.divider,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Fixed filter button ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: GestureDetector(
              onTap: onFilterTap,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.tune, color: Colors.white, size: 20),
                    // Active filter indicator dot
                    if (hasActiveFilters)
                      Positioned(
                        top: -3,
                        right: -3,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
