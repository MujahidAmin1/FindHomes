import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/formatters.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

/// Full-width vertical property card used in the Explore listings view.
///
/// Displays the primary image with a listing-type badge overlay,
/// then title, price, location, and specs below.
class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback? onTap;

  const PropertyCard({super.key, required this.property, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  // ── Image with badge overlay ──────────────────────────────────────────

  Widget _buildImage() {
    final imageUrl = _primaryImageUrl;

    return Stack(
      children: [
        // Property image
        SizedBox(
          height: 200,
          width: double.infinity,
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surface,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => _imagePlaceholder,
                )
              : _imagePlaceholder,
        ),

        // Listing type badge — top-left
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _listingBadgeColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _listingBadgeLabel,
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ),

        // Favourite heart — top-right
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: .85),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.favorite_border,
              size: 18,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }

  // ── Content section ───────────────────────────────────────────────────

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            property.title,
            style: AppTypography.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  property.locationText,
                  style: AppTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Price
          Text(
            _formattedPrice,
            style: AppTypography.priceSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),

          // Specs row
          if (_hasSpecs) _buildSpecsRow(),
        ],
      ),
    );
  }

  Widget _buildSpecsRow() {
    return Row(
      children: [
        if (property.bedrooms != null) ...[
          _specItem(Icons.bed_outlined, '${property.bedrooms}'),
          const SizedBox(width: 16),
        ],
        if (property.bathrooms != null) ...[
          _specItem(Icons.bathtub_outlined, '${property.bathrooms}'),
          const SizedBox(width: 16),
        ],
        if (property.sizeSqm != null)
          _specItem(
              Icons.square_foot, property.sizeSqm!.toStringAsFixed(0)),
      ],
    );
  }

  Widget _specItem(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: 4),
        Text(value, style: AppTypography.specData),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  String get _primaryImageUrl {
    if (property.images.isEmpty) return '';
    final primary = property.images.where((img) => img.isPrimary).toList();
    return primary.isNotEmpty
        ? primary.first.imageUrl
        : property.images.first.imageUrl;
  }

  bool get _hasSpecs =>
      property.bedrooms != null ||
      property.bathrooms != null ||
      property.sizeSqm != null;

  String get _formattedPrice {
    final base = AppFormatters.formatCurrency(
      property.price.toString(),
      property.currency,
    );
    if (property.listingType == ListingType.rent) return '$base / yr';
    if (property.listingType == ListingType.shortlet) return '$base / night';
    return base;
  }

  Color get _listingBadgeColor => switch (property.listingType) {
        ListingType.sale => AppColors.saleTag,
        ListingType.rent => AppColors.rentTag,
        ListingType.shortlet => AppColors.shortletTag,
      };

  String get _listingBadgeLabel => switch (property.listingType) {
        ListingType.sale => 'FOR SALE',
        ListingType.rent => 'FOR RENT',
        ListingType.shortlet => 'SHORTLET',
      };

  Widget get _imagePlaceholder => Container(
        color: AppColors.surface,
        alignment: Alignment.center,
        child:
            const Icon(Icons.home_outlined, size: 48, color: AppColors.muted),
      );
}
