import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

/// Modal bottom sheet for advanced property filters:
/// listing type and price range.
class FilterBottomSheet extends StatefulWidget {
  final ListingType? initialListingType;
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final void Function({
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
  }) onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    this.initialListingType,
    this.initialMinPrice,
    this.initialMaxPrice,
    required this.onApply,
    required this.onReset,
  });

  /// Shows the filter bottom sheet and returns the selected filters.
  static void show(
    BuildContext context, {
    ListingType? currentListingType,
    double? currentMinPrice,
    double? currentMaxPrice,
    required void Function({
      ListingType? listingType,
      double? minPrice,
      double? maxPrice,
    }) onApply,
    required VoidCallback onReset,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(
        initialListingType: currentListingType,
        initialMinPrice: currentMinPrice,
        initialMaxPrice: currentMaxPrice,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late ListingType? _listingType;
  late final TextEditingController _minPriceCtrl;
  late final TextEditingController _maxPriceCtrl;

  static const _listingOptions = <ListingType?, String>{
    null: 'All',
    ListingType.sale: 'For Sale',
    ListingType.rent: 'For Rent',
    ListingType.shortlet: 'Shortlet',
  };

  @override
  void initState() {
    super.initState();
    _listingType = widget.initialListingType;
    _minPriceCtrl = TextEditingController(
      text: widget.initialMinPrice?.toStringAsFixed(0) ?? '',
    );
    _maxPriceCtrl = TextEditingController(
      text: widget.initialMaxPrice?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    widget.onApply(
      listingType: _listingType,
      minPrice: double.tryParse(_minPriceCtrl.text.trim()),
      maxPrice: double.tryParse(_maxPriceCtrl.text.trim()),
    );
    Navigator.of(context).pop();
  }

  void _reset() {
    widget.onReset();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Filter Properties', style: AppTypography.titleMedium),
          const SizedBox(height: 24),

          // ── Listing Type ────────────────────────────────────────────
          Text(
            'Listing Type',
            style: AppTypography.caption.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _listingOptions.entries.map((entry) {
              final isSelected = _listingType == entry.key;
              return ChoiceChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => _listingType = entry.key),
                labelStyle: AppTypography.caption.copyWith(
                  color: isSelected ? AppColors.card : AppColors.ink,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                backgroundColor: AppColors.card,
                selectedColor: AppColors.primary,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                showCheckmark: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // ── Price Range ─────────────────────────────────────────────
          Text(
            'Price Range',
            style: AppTypography.caption.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minPriceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: AppTypography.body,
                  decoration: InputDecoration(
                    hintText: 'Min',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.muted.withValues(alpha: .5),
                    ),
                    prefixText: '₦ ',
                    prefixStyle: AppTypography.bodyMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('–',
                    style: AppTypography.titleMedium
                        .copyWith(color: AppColors.muted)),
              ),
              Expanded(
                child: TextFormField(
                  controller: _maxPriceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: AppTypography.body,
                  decoration: InputDecoration(
                    hintText: 'Max',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.muted.withValues(alpha: .5),
                    ),
                    prefixText: '₦ ',
                    prefixStyle: AppTypography.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── Actions ─────────────────────────────────────────────────
          AppButton(label: 'Apply Filters', onPressed: _apply),
          const SizedBox(height: 10),
          AppButton.outlined(label: 'Reset Filters', onPressed: _reset),
        ],
      ),
    );
  }
}
