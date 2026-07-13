class PropertyImage {
  final String id;
  final String propertyId;
  final String imageUrl;
  final String publicId;
  final bool isPrimary;
  final int sortOrder;

  PropertyImage({
    required this.id,
    required this.propertyId,
    required this.imageUrl,
    required this.publicId,
    required this.isPrimary,
    this.sortOrder = 0,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'] as String? ?? '',
      propertyId: json['property_id'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      publicId: json['public_id'] as String? ?? '',
      isPrimary: json['is_primary'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'image_url': imageUrl,
      'public_id': publicId,
      'is_primary': isPrimary,
      'sort_order': sortOrder,
    };
  }
}

class PropertyModel {
  final String id;
  final String agentId;
  final String title;
  final String description;
  final double price;
  final String currency;
  final PropertyType propertyType;
  final ListingType listingType;
  final PropertyStatus status;
  final int? bedrooms;
  final int? bathrooms;
  final double? sizeSqm;
  final String locationText;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PropertyImage> images;

  PropertyModel({
    required this.id,
    required this.agentId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.propertyType,
    required this.listingType,
    required this.status,
    this.bedrooms,
    this.bathrooms,
    this.sizeSqm,
    required this.locationText,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    required this.images,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    // Parse price safely — backend sends it as a string like "150000000.00"
    final rawPrice = json['price'];
    final double parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    // Parse images safely — backend may return null or a list of image objects
    List<PropertyImage> parsedImages = [];
    final rawImages = json['images'];
    if (rawImages != null && rawImages is List) {
      parsedImages = rawImages
          .map((e) => PropertyImage.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return PropertyModel(
      id: json['id'] as String,
      agentId: json['agent_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: parsedPrice,
      currency: json['currency'] as String? ?? 'NGN',
      propertyType: PropertyType.values.byName(json['property_type']),
      listingType: ListingType.values.byName(json['listing_type']),
      status: PropertyStatus.values.byName(json['status'] ?? 'available'),
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      sizeSqm: (json['size_sqm'] as num?)?.toDouble(),
      locationText: json['location_text'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      images: parsedImages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agent_id': agentId,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'property_type': propertyType.name,
      'listing_type': listingType.name,
      'status': status.name,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'size_sqm': sizeSqm,
      'location_text': locationText,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}

enum PropertyType {
  house,
  apartment,
  land,
  commercial,
}

enum ListingType {
  sale,
  rent,
  shortlet,
}

enum PropertyStatus {
  available,
  sold,
  rented,
  inactive,
}