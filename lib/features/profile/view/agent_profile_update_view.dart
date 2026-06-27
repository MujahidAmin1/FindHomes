import 'package:another_flushbar/flushbar.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/core/widgets/app_text_field.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/navbar/agent_navbar.dart';
import 'package:find_homes/features/profile/notifier/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgentProfileUpdateView extends ConsumerStatefulWidget {
  const AgentProfileUpdateView({super.key});

  @override
  ConsumerState<AgentProfileUpdateView> createState() =>
      _AgentProfileUpdateViewState();
}

class _AgentProfileUpdateViewState
    extends ConsumerState<AgentProfileUpdateView> {
  late final TextEditingController _agencyNameController;
  int _experienceYears = 2;

  @override
  void initState() {
    super.initState();
    _agencyNameController = TextEditingController();
  }

  @override
  void dispose() {
    _agencyNameController.dispose();
    super.dispose();
  }

  void _submit() {
    ref.read(agentProfileNotifierProvider.notifier).updateAgentProfile(
          agencyName: _agencyNameController.text.trim(),
          experienceYears: _experienceYears,
        );
  }

  @override
  Widget build(BuildContext context) {
    final agentProfileState = ref.watch(agentProfileNotifierProvider);

    ref.listen(agentProfileNotifierProvider, (prev, next) {
      final wasLoading = prev?.isLoading ?? false;
      if (!wasLoading || next.isLoading) return;

      if (next.hasError) {
        _showFlushbar(
          message: BackendError.extractMessage(next.error!),
          isError: true,
        );
        return;
      }

      if (next.hasValue && next.value != null) {
        _showFlushbar(message: 'Agent profile created successfully.');
        // Mark onboarding completed and navigate to agent navbar
        ref
            .read(authNotifierProvider.notifier)
            .updateOnboardingStatus(OnboardingStatus.completed);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AgentNavbar()),
          (_) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Step 2 of 2',
          style: AppTypography.caption.copyWith(color: AppColors.muted),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              color: AppColors.primary,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Text(
                      'Create your account',
                      style: AppTypography.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us about your professional background to verify your agent status.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text('Your agency', style: AppTypography.sectionHeader),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Agency name',
                      hintText: 'e.g. FindHomes Real Estate',
                      prefixIcon: Icons.business_outlined,
                      controller: _agencyNameController,
                      optional: true,
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Years of experience',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          // Minus button
                          InkWell(
                            onTap: _experienceYears > 0
                                ? () => setState(
                                    () => _experienceYears--)
                                : null,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right:
                                      BorderSide(color: AppColors.divider),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.remove,
                                color: _experienceYears > 0
                                    ? AppColors.ink
                                    : AppColors.muted,
                                size: 22,
                              ),
                            ),
                          ),
                          // Value display
                          Expanded(
                            child: Center(
                              child: Text(
                                '$_experienceYears',
                                style: AppTypography.titleLarge,
                              ),
                            ),
                          ),
                          // Plus button
                          InkWell(
                            onTap: () =>
                                setState(() => _experienceYears++),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left:
                                      BorderSide(color: AppColors.divider),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.add,
                                color: AppColors.ink,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: AppButton(
                label: 'Create account',
                loading: agentProfileState.isLoading,
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFlushbar({required String message, bool isError = false}) {
    Flushbar<void>(
      messageText: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.card),
      ),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: AppColors.card,
      ),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}