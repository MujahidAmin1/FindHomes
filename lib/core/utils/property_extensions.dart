import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/utils/formatters.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

extension PropertyModelX on PropertyModel {
  String get primaryImageUrl {
    if (images.isEmpty) return '';
    try {
      return images.firstWhere((img) => img.isPrimary).imageUrl;
    } catch (_) {
      return images.first.imageUrl;
    }
  }

  bool get hasSpecs => bedrooms != null || bathrooms != null || sizeSqm != null;

  String get formattedPrice {
    final base = AppFormatters.formatCurrency(price.toString(), currency);
    if (listingType == ListingType.rent) return '$base / yr';
    if (listingType == ListingType.shortlet) return '$base / night';
    return base;
  }
}

extension ListingTypeX on ListingType {
  String get badgeLabel => switch (this) {
        ListingType.sale => 'FOR SALE',
        ListingType.rent => 'FOR RENT',
        ListingType.shortlet => 'SHORTLET',
      };

  Color get badgeColor => switch (this) {
        ListingType.sale => AppColors.saleTag,
        ListingType.rent => AppColors.rentTag,
        ListingType.shortlet => AppColors.shortletTag,
      };
}

extension PropertyTypeX on PropertyType {
  String get label => switch (this) {
        PropertyType.house => 'HOUSE',
        PropertyType.apartment => 'APARTMENT',
        PropertyType.land => 'LAND',
        PropertyType.commercial => 'COMMERCIAL',
      };

  String get shortLabel => switch (this) {
        PropertyType.house => 'House',
        PropertyType.apartment => 'Apt',
        PropertyType.land => 'Land',
        PropertyType.commercial => 'Comm',
      };
}
