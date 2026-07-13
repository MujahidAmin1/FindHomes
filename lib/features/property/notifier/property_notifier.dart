import 'package:find_homes/core/locator.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:find_homes/features/property/model/property_list_state.dart';
import 'package:find_homes/features/property/service/property_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _kPageLimit = 20;

final propertyNotifierProvider =
    AsyncNotifierProvider<PropertyNotifier, PropertyListState>(
  PropertyNotifier.new,
);

class PropertyNotifier extends AsyncNotifier<PropertyListState> {
  PropertyService get _service => serviceLocator.get<PropertyService>();


  @override
  Future<PropertyListState> build() async {
    final items = await _service.getProperties(page: 1, limit: _kPageLimit);
    return PropertyListState(
      properties: items,
      currentPage: 1,
      hasReachedEnd: items.length < _kPageLimit,
      isInitialLoad: false,
    );
  }

  // ── Pagination ──────────────────────────────────────────────────────────

  /// Appends the next page of results. No-op if already loading or at end.
  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || current.hasReachedEnd) {
      return;
    }

    // Optimistically show the bottom loader
    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.currentPage + 1;
      final items = await _service.getProperties(
        page: nextPage,
        limit: _kPageLimit,
        propertyType: current.selectedType,
        listingType: current.listingType,
        minPrice: current.minPrice,
        maxPrice: current.maxPrice,
      );

      state = AsyncData(current.copyWith(
        properties: [...current.properties, ...items],
        currentPage: nextPage,
        isLoadingMore: false,
        hasReachedEnd: items.length < _kPageLimit,
      ));
    } catch (e, st) {
      // Roll back the loader but keep existing data
      state = AsyncData(current.copyWith(isLoadingMore: false));
      // Re-expose the error so the UI can show a snackbar if desired
      state = AsyncError(e, st);
    }
  }

  // ── Category chip filter ────────────────────────────────────────────────

  /// Sets the active property type filter and reloads from page 1.
  /// Pass `null` for "All".
  Future<void> setPropertyType(PropertyType? type) async {
    final current = state.value;

    state = const AsyncLoading();

    try {
      final items = await _service.getProperties(
        page: 1,
        limit: _kPageLimit,
        propertyType: type,
        listingType: current?.listingType,
        minPrice: current?.minPrice,
        maxPrice: current?.maxPrice,
      );

      state = AsyncData(PropertyListState(
        properties: items,
        currentPage: 1,
        hasReachedEnd: items.length < _kPageLimit,
        isInitialLoad: false,
        selectedType: type,
        listingType: current?.listingType,
        minPrice: current?.minPrice,
        maxPrice: current?.maxPrice,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ── Bottom-sheet filters ────────────────────────────────────────────────

  /// Applies advanced filters from the bottom sheet and reloads from page 1.
  Future<void> applyFilters({
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
  }) async {
    final current = state.value;

    state = const AsyncLoading();

    try {
      final items = await _service.getProperties(
        page: 1,
        limit: _kPageLimit,
        propertyType: current?.selectedType,
        listingType: listingType,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      state = AsyncData(PropertyListState(
        properties: items,
        currentPage: 1,
        hasReachedEnd: items.length < _kPageLimit,
        isInitialLoad: false,
        selectedType: current?.selectedType,
        listingType: listingType,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Removes all filters and reloads from page 1.
  Future<void> clearFilters() async {
    state = const AsyncLoading();

    try {
      final items = await _service.getProperties(page: 1, limit: _kPageLimit);
      state = AsyncData(PropertyListState(
        properties: items,
        currentPage: 1,
        hasReachedEnd: items.length < _kPageLimit,
        isInitialLoad: false,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}