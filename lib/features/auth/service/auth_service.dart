import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/token_storage.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/auth/model/user.dart';

class AuthService {
  final _dio = serviceLocator.get<Dio>();
  static const _tag = "AuthService";

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.d('POST /auth/login $email', tag: _tag,);
      final response = await _dio.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      final payload = UserResponse.fromJson(data);
      await serviceLocator.get<TokenStorageService>().saveTokens(
        accessToken: payload.accessToken,
        refreshToken: payload.refreshToken,
      );
      return payload.user;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Login failed. Please try again.',
      );
    }
  }

  Future<UserModel> register(String email, String password, UserRole role) async {
    try {
      AppLogger.d('POST /auth/register  $email', tag: _tag,);
      final response = await _dio.post(
        Endpoints.register,
        data: {'email': email, 'password': password, 'role': role.name},
      );
      final data = response.data as Map<String, dynamic>;
      final payload = UserResponse.fromJson(data);
      await serviceLocator.get<TokenStorageService>().saveTokens(
        accessToken: payload.accessToken,
        refreshToken: payload.refreshToken,
      );
      return payload.user;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Registration failed. Please try again.',
      );
    }
  }

  Future<bool> refreshTokens() async {
    final refreshToken = await serviceLocator
        .get<TokenStorageService>()
        .getRefreshToken();
    try {
      final response = await _dio.post(
        Endpoints.refresh,
        data: {'refresh': refreshToken},
      );
      final data = UserResponse.fromJson(response.data as Map<String, dynamic>);
      await serviceLocator.get<TokenStorageService>().saveTokens(
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      );
      return true;
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to refresh tokens. Please sign in again.',
      );
    }
  }

  Future<void> logout() async {
    final refreshToken = await serviceLocator
        .get<TokenStorageService>()
        .getRefreshToken();
    try {
      AppLogger.d('POST /auth/logout', tag: _tag);
      await _dio.post(
        Endpoints.logout,
        data: {"refresh_token": refreshToken}
      );
      await serviceLocator.get<TokenStorageService>().clearTokens();
    } on DioException catch (e) {
      AppLogger.e('Failed to logout', tag: _tag, error: e);
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      AppLogger.d('GET /auth/me', tag: _tag);
      final response = await _dio.get(Endpoints.getCurrentUser);
      final data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('Failed to parse /auth/me response', tag: _tag, error: e);
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to fetch current user.',
      );
    }
  }

  Future<UserModel> patchOnboardingStatus(OnboardingStatus status) async {
    try {
      AppLogger.d('PATCH /auth/onboarding-status → ${status.name}', tag: _tag);
      final response = await _dio.patch(
        Endpoints.onboardingStatus,
        data: {'onboarding_status': status.name},
      );
      final data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to update onboarding status.',
      );
    }
  }

  
}
