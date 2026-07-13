import 'dart:io';

import 'package:find_homes/core/locator.dart';
import 'package:find_homes/features/agent%20dashboard/model/create_listing_draft.dart';
import 'package:find_homes/features/agent%20dashboard/model/property_create.dart';
import 'package:find_homes/features/agent%20dashboard/service/dashboard_service.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createListingNotifierProvider =
    NotifierProvider<CreateListingNotifier, CreateListingDraft>(
  CreateListingNotifier.new,
);

class CreateListingNotifier extends Notifier<CreateListingDraft> {
  @override
  CreateListingDraft build() => const CreateListingDraft();

  // ── Step writers ──────────────────────────────────────────────────────────

  void updateStep1({
    required String title,
    required String description,
    required PropertyType propertyType,
    required ListingType listingType,
  }) {
    state = state.copyWith(
      title: title,
      description: description,
      propertyType: propertyType,
      listingType: listingType,
    );
  }

  void updateStep2({
    required String currency,
    required double price,
    required int bedrooms,
    required int bathrooms,
    double? sizeSqm,
  }) {
    state = state.copyWith(
      currency: currency,
      price: price,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      sizeSqm: sizeSqm,
    );
  }

  void updateStep3({
    required String location,
    double? latitude,
    double? longitude,
  }) {
    state = state.copyWith(
      location: location,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void updateStep4({required List<File> images}) {
    state = state.copyWith(images: images);
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  /// Builds a [PropertyCreateRequest] from the current draft and sends it
  /// to the backend via [AgentDashboardService]. Throws on failure.
  Future<void> submit() async {
    final service = serviceLocator.get<AgentDashboardService>();
    final draft = state;

    final request = PropertyCreateRequest(
      title: draft.title,
      description: draft.description,
      price: draft.price!,
      currency: draft.currency,
      propertyType: draft.propertyType!,
      listingType: draft.listingType!,
      locationText: draft.location,
      latitude: draft.latitude,
      longitude: draft.longitude,
      bedrooms: draft.bedrooms,
      bathrooms: draft.bathrooms,
      sizeSqm: draft.sizeSqm,
      images: draft.images,
    );

    await service.createProperty(request);
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  void reset() {
    state = const CreateListingDraft();
  }
}
