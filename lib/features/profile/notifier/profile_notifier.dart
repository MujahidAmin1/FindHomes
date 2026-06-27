import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/profile/model/agent_profile.dart';
import 'package:find_homes/features/profile/model/user_profile.dart';
import 'package:find_homes/features/profile/service/profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── User Profile Notifier ────────────────────────────────────────────────────

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile?>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<UserProfile?> {
  ProfileService get _service => serviceLocator.get<ProfileService>();

  @override
  Future<UserProfile?> build() async => null;

  Future<void> updateProfile(
    String phoneNumber,
    String bio, {
    required String fullName,
    required String location,
  }) async {
    state = const AsyncValue.loading();
    state = await _guard(
      () => _service.profileUpdate(fullName, phoneNumber, bio, location),
    );
  }

  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    state = await _guard(_service.getUserProfile);
  }

  Future<AsyncValue<UserProfile?>> _guard(
    Future<UserProfile> Function() action,
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

// ── Agent Profile Notifier ───────────────────────────────────────────────────

final agentProfileNotifierProvider =
    AsyncNotifierProvider<AgentProfileNotifier, AgentProfile?>(
  AgentProfileNotifier.new,
);

class AgentProfileNotifier extends AsyncNotifier<AgentProfile?> {
  ProfileService get _service => serviceLocator.get<ProfileService>();

  @override
  Future<AgentProfile?> build() async => null;

  Future<void> updateAgentProfile({
    required String agencyName,
    required int experienceYears,
  }) async {
    state = const AsyncValue.loading();
    state = await _guard(
      () => _service.agentProfileUpdate(agencyName, experienceYears, false),
    );
  }

  Future<AsyncValue<AgentProfile?>> _guard(
    Future<AgentProfile> Function() action,
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
