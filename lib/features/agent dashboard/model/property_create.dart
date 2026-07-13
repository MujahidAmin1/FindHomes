import 'dart:io';

import 'package:find_homes/features/property/model/property.dart';

class PropertyCreateRequest {
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
  final List<File> images;

  PropertyCreateRequest({
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'NGN',
    required this.propertyType,
    required this.listingType,
    this.status = PropertyStatus.available,
    this.bedrooms,
    this.bathrooms,
    this.sizeSqm,
    required this.locationText,
    this.latitude,
    this.longitude,
    required this.images,
  });

  /// Serialises the non-file fields to JSON.
  /// Image files are sent separately as multipart uploads.
  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}