
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/agent%20dashboard/model/property_create.dart';
import 'package:find_homes/features/property/model/property.dart';

class AgentDashboardService{
  final String _tag = 'AgentDashboard Service';
  final Dio _dio = serviceLocator.get<Dio>();

  /// Creates a property listing using multipart/form-data.
  ///
  /// The FastAPI backend expects form fields + `images` as `UploadFile` list.
  Future<PropertyModel> createProperty(PropertyCreateRequest property) async {
    try {
      AppLogger.d('POST /properties/', tag: _tag);

      // ── Build multipart form data ──────────────────────────────────────
      final formData = FormData();

      // Required form fields
      formData.fields.addAll([
        MapEntry('title', property.title),
        MapEntry('description', property.description),
        MapEntry('price', property.price.toString()),
        MapEntry('currency', property.currency),
        MapEntry('property_type', property.propertyType.name),
        MapEntry('listing_type', property.listingType.name),
        MapEntry('status', property.status.name),
        MapEntry('location_text', property.locationText),
      ]);

      // Optional form fields
      if (property.bedrooms != null) {
        formData.fields
            .add(MapEntry('bedrooms', property.bedrooms.toString()));
      }
      if (property.bathrooms != null) {
        formData.fields
            .add(MapEntry('bathrooms', property.bathrooms.toString()));
      }
      if (property.sizeSqm != null) {
        formData.fields
            .add(MapEntry('size_sqm', property.sizeSqm.toString()));
      }
      if (property.latitude != null) {
        formData.fields
            .add(MapEntry('latitude', property.latitude.toString()));
      }
      if (property.longitude != null) {
        formData.fields
            .add(MapEntry('longitude', property.longitude.toString()));
      }

      // Image files — each keyed as 'images' for FastAPI list[UploadFile]
      for (final file in property.images) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        Endpoints.property,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;
      final payload = PropertyModel.fromJson(data);
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Property creation failed',
      );
    }
  }

  Future updateProperty(String propertyId, PropertyCreateRequest property) async {
    try {
      AppLogger.d('PUT /properties/$propertyId', tag: _tag);
      final response = await _dio.put(
        Endpoints.updateProperty(propertyId),
        data: property.toJson(),
      );

      final data = response.data as Map<String, dynamic>;
      final payload = PropertyModel.fromJson(data);
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'update failed',
      );
    }
  }
  
  Future deleteProperty(String propertyId) async {
    try {
      AppLogger.d('DELETE /properties/$propertyId', tag: _tag);
      final response = await _dio.delete(
        Endpoints.deleteProperty(propertyId),
      );

      final data = response.data as Map<String, dynamic>;
      final payload = PropertyModel.fromJson(data);
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'delete failed',
      );
    }
  }

  Future<List<PropertyModel>> getAgentProperties(String agentId) async {
    try {
      AppLogger.d('GET /properties/agent/$agentId', tag: _tag);
      final response = await _dio.get(
        Endpoints.getagentProperties(agentId),
      );

      final List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else {
        data = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
      }

      final List<PropertyModel> payload =
          data.map((e) => PropertyModel.fromJson(e as Map<String, dynamic>)).toList();
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to fetch agent properties',
      );
    }
  }

}
