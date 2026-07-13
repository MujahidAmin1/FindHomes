import 'dart:io';

import 'package:find_homes/features/property/model/property.dart';

/// Immutable draft model for the multi-step create listing flow.
/// Single source of truth — updated only when a step validates successfully.
class CreateListingDraft {
  // ── Step 1 — Basic Details ────────────────────────────────────────────────
  final String title;
  final String description;
  final PropertyType? propertyType;
  final ListingType? listingType;

  // ── Step 2 — Details & Price ──────────────────────────────────────────────
  final String currency;
  final double? price;
  final int bedrooms;
  final int bathrooms;
  final double? sizeSqm;

  // ── Step 3 — Location ─────────────────────────────────────────────────────
  final String location;
  final double? latitude;
  final double? longitude;

  // ── Step 4 — Photos ───────────────────────────────────────────────────────
  final List<File> images;

  const CreateListingDraft({
    this.title = '',
    this.description = '',
    this.propertyType,
    this.listingType,
    this.currency = 'NGN',
    this.price,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.sizeSqm,
    this.location = '',
    this.latitude,
    this.longitude,
    this.images = const [],
  });

  CreateListingDraft copyWith({
    String? title,
    String? description,
    PropertyType? propertyType,
    ListingType? listingType,
    String? currency,
    double? price,
    int? bedrooms,
    int? bathrooms,
    double? sizeSqm,
    String? location,
    double? latitude,
    double? longitude,
    List<File>? images,
  }) {
    return CreateListingDraft(
      title: title ?? this.title,
      description: description ?? this.description,
      propertyType: propertyType ?? this.propertyType,
      listingType: listingType ?? this.listingType,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      sizeSqm: sizeSqm ?? this.sizeSqm,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
    );
  }
}
