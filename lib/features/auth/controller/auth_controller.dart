import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/token_storage.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/auth/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider =
    AsyncNotifierProvider.autoDispose<AuthNotifier, UserModel?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  static const _tag = "AuthController";
  @override
  Future<UserModel?> build() async {
    final hasTokens =
        await serviceLocator.get<TokenStorageService>().hasTokens();
    if (!hasTokens) return null;
    return _authService.getCurrentUser();
  }

  AuthService get _authService => serviceLocator.get<AuthService>();

  Future<void> register(String email, String password, String role) async {
    AppLogger.d('POST /auth/register — $email', tag: _tag);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService
          .register(email, password, role)
          .then((u) => u as UserModel?),
    );
  }

  Future<void> login(String email, String password) async {
    AppLogger.d('POST /auth/register — $email', tag: _tag);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService
          .login(email: email, password: password)
          .then((u) => u as UserModel?),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _authService.logout();
    state = const AsyncValue.data(null);
  }

  Future<void> refreshCurrentUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.getCurrentUser().then((u) => u as UserModel?),
    );
  }
}
