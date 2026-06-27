import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/token_storage.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/auth/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(
      AuthNotifier.new,
    );

class AuthNotifier extends AsyncNotifier<UserModel?> {
  static const _tag = "AuthController";

  @override
  Future<UserModel?> build() async {
    final hasTokens = await serviceLocator
        .get<TokenStorageService>()
        .hasTokens();
    if (!hasTokens) return null;
    return _authService.getCurrentUser();
  }

  AuthService get _authService => serviceLocator.get<AuthService>();

  Future<void> register(String email, String password, UserRole role) async {
    AppLogger.d('POST /auth/register - $email', tag: _tag);
    state = const AsyncValue.loading();
    state = await _guardAuth(
      () => _authService.register(email, password, role),
    );
  }

  Future<void> login(String email, String password) async {
    AppLogger.d('POST /auth/login - $email', tag: _tag);
    state = const AsyncValue.loading();
    state = await _guardAuth(
      () => _authService.login(email: email, password: password),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _authService.logout();
    state = const AsyncValue.data(null);
  }

  Future<void> refreshCurrentUser() async {
    state = const AsyncValue.loading();
    state = await _guardAuth(_authService.getCurrentUser);
  }

  Future<void> updateOnboardingStatus(OnboardingStatus status) async {
    state = const AsyncValue.loading();
    state = await _guardAuth(
      () => _authService.patchOnboardingStatus(status),
    );
  }

  Future<AsyncValue<UserModel?>> _guardAuth(
    Future<UserModel> Function() action,
  ) async {
    try {
      return AsyncValue.data(await action());
    } catch (error, stackTrace) {
      return AsyncValue.error(
        BackendException(BackendError.extractMessage(error)),
        stackTrace,
      );
    }
  }
}
