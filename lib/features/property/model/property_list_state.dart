import 'package:find_homes/features/property/model/property.dart';

/// Immutable state for the property listings screen.
///
/// Holds the accumulated page results, pagination bookkeeping,
/// and active filter selections.
class PropertyListState {
  final List<PropertyModel> properties;
  final int currentPage;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final bool isInitialLoad;

  // ── Filters ──────────────────────────────────────────────────────────────
  final PropertyType? selectedType;
  final ListingType? listingType;
  final double? minPrice;
  final double? maxPrice;

  const PropertyListState({
    this.properties = const [],
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.isInitialLoad = true,
    this.selectedType,
    this.listingType,
    this.minPrice,
    this.maxPrice,
  });

  PropertyListState copyWith({
    List<PropertyModel>? properties,
    int? currentPage,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    bool? isInitialLoad,
    PropertyType? Function()? selectedType,
    ListingType? Function()? listingType,
    double? Function()? minPrice,
    double? Function()? maxPrice,
  }) {
    return PropertyListState(
      properties: properties ?? this.properties,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      listingType: listingType != null ? listingType() : this.listingType,
      minPrice: minPrice != null ? minPrice() : this.minPrice,
      maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
    );
  }

  /// Whether any advanced filters (beyond category chips) are active.
  bool get hasActiveFilters =>
      listingType != null || minPrice != null || maxPrice != null;
}
