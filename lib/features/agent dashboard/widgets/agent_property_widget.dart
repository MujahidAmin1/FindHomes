import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../property/model/property.dart';

class AgentPropertyWidget extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AgentPropertyWidget({
    super.key,
    required this.property,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // For now we'll mock the views since it's not in the model
    final int views = 245;

    String imageUrl = '';
    if (property.images.isNotEmpty) {
      final primaryImages = property.images.where((img) => img.isPrimary).toList();
      if (primaryImages.isNotEmpty) {
        imageUrl = primaryImages.first.imageUrl;
      } else {
        imageUrl = property.images.first.imageUrl;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
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
          // Image and Status Stack
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl.isEmpty
                    ? const Icon(Icons.home, size: 50, color: AppColors.muted)
                    : null,
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(property.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusTextColor(property.status),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _capitalize(property.status.name),
                        style: TextStyle(
                          color: _getStatusTextColor(property.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppFormatters.formatCurrency(property.price.toString(), property.currency),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.locationText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.muted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amenities (Beds, Baths, Sqm)
                Row(
                  children: [
                    if (property.bedrooms != null) ...[
                      const Icon(Icons.king_bed_outlined, size: 18, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(
                        '${property.bedrooms} Beds',
                        style: const TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (property.bathrooms != null) ...[
                      const Icon(Icons.bathtub_outlined, size: 18, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(
                        '${property.bathrooms} Baths',
                        style: const TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (property.sizeSqm != null) ...[
                      const Icon(Icons.square_foot, size: 18, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(
                        '${property.sizeSqm?.toStringAsFixed(0)} sqm',
                        style: const TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                    ],
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(color: AppColors.divider, thickness: 1),
                ),

                // Footer (Listed Date, Views, Edit, Delete)
                Row(
                  children: [
                    Text(
                      'Listed: ${property.createdAt != null ? AppFormatters.formatDate(property.createdAt!) : 'N/A'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: AppColors.muted)),
                    const SizedBox(width: 8),
                    const Icon(Icons.visibility, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '$views Views',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),

                    // Actions
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: onEdit,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.edit_outlined, size: 20, color: AppColors.muted),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: onDelete,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.delete_outline, size: 20, color: AppColors.muted),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBgColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.available:
        return AppColors.availableBg;
      case PropertyStatus.sold:
        return AppColors.soldBg;
      case PropertyStatus.rented:
        return AppColors.rentedBg;
      case PropertyStatus.inactive:
        return AppColors.inactiveBg;
    }
  }

  Color _getStatusTextColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.available:
        return AppColors.success;
      case PropertyStatus.sold:
        return AppColors.error;
      case PropertyStatus.rented:
        return AppColors.rentedText;
      case PropertyStatus.inactive:
        return AppColors.inactiveText;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
