import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/profile/model/agent_profile.dart';
import 'package:find_homes/features/profile/model/user_profile.dart';

class ProfileService {
  final _dio = serviceLocator.get<Dio>();
  static const _tag = "ProfileService";

  Future<UserProfile> profileUpdate(
    String fullname,
    String phonenumber,
    String bio,
    String location,
  ) async {
    try {
      AppLogger.d('PUT /profile', tag: _tag);
      final response = await _dio.put(
        Endpoints.profile,
        data: {
          "full_name": fullname,
          "phone_number": phonenumber,
          "bio": bio,
          "location": location,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final payload = UserProfile.fromJson(data);
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'update failed',
      );
    }
  }

  Future<AgentProfile> agentProfileUpdate(
    String agencyName,
    int experienceYears,
    bool isVerified,
  ) async {
    try {
      AppLogger.d('PUT /profile/agent_profile', tag: _tag);
      final response = await _dio.put(
        Endpoints.agentProfile,
        data: {"agency_name": agencyName, "experience_years": experienceYears},
      );

      final data = response.data as Map<String, dynamic>;
      final payload = AgentProfile.fromJson(data);
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'update failed',
      );
    }
  }

  Future<UserProfile> getUserProfile() async {
    try {
      AppLogger.d('GET /profile', tag: _tag);
      final response = await _dio.get(Endpoints.profile);

      final data = response.data as Map<String, dynamic>;
      final payload = UserProfile.fromJson(data);
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'update failed',
      );
    }
  }
   Future<UserProfile> getAgentProfile() async {
    try {
      AppLogger.d('GET /profile/agent_profile', tag: _tag);
      final response = await _dio.get(Endpoints.agentProfile);

      final data = response.data as Map<String, dynamic>;
      final payload = UserProfile.fromJson(data);
      return payload;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'update failed',
      );
    }
  }
}
