import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/property/model/property.dart';

class PropertyService {
  final String _tag = "PropertyService";
  final Dio _dio = serviceLocator.get<Dio>();

  /// Fetches a paginated list of properties with optional filters.
  ///
  /// Maps directly to the backend query params:
  /// `page`, `limit`, `property_type`, `listing_type`, `min_price`, `max_price`.
  Future<List<PropertyModel>> getProperties({
    int page = 1,
    int limit = 20,
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (propertyType != null) {
        queryParams['property_type'] = propertyType.name;
      }
      if (listingType != null) {
        queryParams['listing_type'] = listingType.name;
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice;
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice;
      }

      AppLogger.d(
        'GET /properties/ page=$page limit=$limit '
        'type=${propertyType?.name} listing=${listingType?.name}',
        tag: _tag,
      );

      final response = await _dio.get(
        Endpoints.property,
        queryParameters: queryParams,
      );

      final List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else {
        data =
            (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
      }

      return data
          .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to fetch properties',
      );
    }
  }

  /// Fetches a single property by its ID.
  Future<PropertyModel> getPropertyById(String propertyId) async {
    try {
      AppLogger.d('GET /properties/$propertyId', tag: _tag);
      final response = await _dio.get(
        Endpoints.getPropertybyId(propertyId),
      );

      final data = response.data as Map<String, dynamic>;
      return PropertyModel.fromJson(data);
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to fetch property',
      );
    }
  }
}