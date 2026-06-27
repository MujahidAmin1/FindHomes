import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/interceptors/auth_interceptor.dart';
import 'package:find_homes/core/interceptors/logging_interceptor.dart';
import 'package:find_homes/core/token_storage.dart';
import 'package:find_homes/features/auth/service/auth_service.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:find_homes/features/profile/service/profile_service.dart';
import 'package:find_homes/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  serviceLocator
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          responseType: ResponseType.json,
          baseUrl: Endpoints.baseUrl,
          // connectTimeout: const Duration(seconds: 8),
          // receiveTimeout: const Duration(seconds: 10),
          // sendTimeout: const Duration(seconds: 8),
          headers: {
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );
      dio.interceptors.addAll([
        AuthInterceptor(
          dio: dio,
          tokenStorage: serviceLocator.get<TokenStorageService>(),
          refreshEndpoint: Endpoints.refresh,
          onTokenExpired: () {
            serviceLocator.get<TokenStorageService>().clearTokens();
            Navigator.pushReplacement(
              navigatorKey.currentState!.context,
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
          },
        ),
        LoggingInterceptor(),
      ]);
      return dio;
    })
    ..registerLazySingleton<TokenStorageService>(
      () => TokenStorageService(serviceLocator.get<FlutterSecureStorage>()),
    )
    ..registerLazySingleton<AuthService>(() => AuthService()
    )
    ..registerLazySingleton<ProfileService>(() => ProfileService());

}