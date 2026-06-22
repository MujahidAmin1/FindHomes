
import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/token_storage.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/features/auth/model/user.dart';



class AuthService {
 final _dio = serviceLocator.get<Dio>();
  static const _tag = "AuthService";

 Future<UserResponse> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(Endpoints.login, data: {
        'email': email,
        'password': password,
      });
      await serviceLocator.get<TokenStorageService>().saveTokens(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );
      final data = response.data['user'];
      return UserResponse.fromJson(data);
    } on DioException catch (e) {
      // Handle login error
      throw Exception('Login failed: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<UserResponse> register(String email, String password, String role) async {
    try {
      final response = await _dio.post(Endpoints.register, data: {
        'role': role,
        'email': email,
        'password': password,
      });
      await serviceLocator.get<TokenStorageService>().saveTokens(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );
      final data = response.data['user'];
      return UserResponse.fromJson(data);
    } on DioException catch (e) {
      // Handle registration error
      throw Exception('Registration failed: ${e.response?.data['message'] ?? e.message}');
    }
  }
  Future<bool> refreshTokens() async {
    final refreshToken = await serviceLocator.get<TokenStorageService>().getRefreshToken();
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
    } catch (e) {
      throw Exception("Failed to refresh tokens: $e");
    }
  }
  Future<void> logout()async{
    try {
      AppLogger.d('POST /auth/logout', tag: _tag);
      await _dio.post(Endpoints.logout);
      await serviceLocator.get<TokenStorageService>().clearTokens();
    } 
    on DioException catch (e) {
      AppLogger.e(
        'Failed to logout',
        tag: _tag,
        error: e,
      );
    }
  }
  Future<UserModel> getCurrentUser() async {
    try {
      AppLogger.d('GET /auth/me', tag: _tag);
      final response = await _dio.get(Endpoints.getCurrentUser);
      final data = response.data;
      return UserModel.fromJson(data['user']);
    } on DioException catch (e) {
      AppLogger.e(
        'Failed to parse /auth/me response',
        tag: _tag,
        error: e,
      );
      throw Exception('Failed to fetch current user: ${e.message} ${e.stackTrace}');
    }
  }
  
}