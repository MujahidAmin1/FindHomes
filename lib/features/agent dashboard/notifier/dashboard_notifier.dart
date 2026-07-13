import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/agent%20dashboard/model/property_create.dart';
import 'package:find_homes/features/agent%20dashboard/service/dashboard_service.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/auth/service/auth_service.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, List<PropertyModel>>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<List<PropertyModel>> {
  AgentDashboardService get _service =>
      serviceLocator.get<AgentDashboardService>();
  AuthService get _authService => serviceLocator.get<AuthService>();
  @override
  Future<List<PropertyModel>> build() async {
   UserModel user = await _authService.getCurrentUser();

    return await serviceLocator.get<AgentDashboardService>().getAgentProperties(user.id);
  }

  // Future<void> fetchAgentProperties(String agentId) async {
  //   state = const AsyncValue.loading();
  //   state = await _guard(() => _service.getAgentProperties(agentId));
  // }

  Future<void> createProperty(PropertyCreateRequest property) async {
    state = const AsyncValue.loading();
    state = await _guard(() async {
      await _service.createProperty(property);
      return state.value ?? [];
    });
  }

  Future<void> updateProperty(
    String propertyId,
    PropertyCreateRequest property,
  ) async {
    state = const AsyncValue.loading();
    state = await _guard(() async {
      await _service.updateProperty(propertyId, property);
      return state.value ?? [];
    });
  }

  Future<void> deleteProperty(String propertyId) async {
    state = const AsyncValue.loading();
    state = await _guard(() async {
      await _service.deleteProperty(propertyId);
      return state.value ?? [];
    });
  }

  Future<AsyncValue<List<PropertyModel>>> _guard(
    Future<List<PropertyModel>> Function() action,
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
