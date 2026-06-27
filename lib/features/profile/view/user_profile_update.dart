import 'package:another_flushbar/flushbar.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/core/widgets/app_text_field.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/navbar/client_navbar.dart';
import 'package:find_homes/features/profile/notifier/profile_notifier.dart';
import 'package:find_homes/features/profile/view/agent_profile_update_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileUpdate extends ConsumerStatefulWidget {
  const UserProfileUpdate({super.key});

  @override
  ConsumerState<UserProfileUpdate> createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends ConsumerState<UserProfileUpdate> {
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _locationCtrl;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    _locationCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final fullName = _fullNameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final bio = _bioCtrl.text.trim();
    final location = _locationCtrl.text.trim();

    if (fullName.isEmpty || location.isEmpty) {
      _showFlushbar(
        message: 'Please fill in all required fields.',
        isError: true,
      );
      return;
    }

    ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(phone, bio, fullName: fullName, location: location);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    ref.listen(profileNotifierProvider, (prev, next) {
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
        _showFlushbar(message: 'Profile updated successfully.');
        final user = ref.read(authNotifierProvider).value;
        if (user != null && user.role == UserRole.agent) {
          // Agent: proceed to agent profile step
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AgentProfileUpdateView()),
          );
        } else {
          // Client: mark onboarding completed, go to navbar
          ref
              .read(authNotifierProvider.notifier)
              .updateOnboardingStatus(OnboardingStatus.completed);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const ClientNavbar()),
            (_) => false,
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Title ────────────────────────────────────────
                    Text(
                      'Complete your profile',
                      style: AppTypography.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us a bit about yourself so others can know you.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Avatar ───────────────────────────────────────
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primaryLight,
                            child: const Icon(
                              Icons.person,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.surface,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: AppColors.card,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Section Header ──────────────────────────────
                    Text(
                      'Personal information',
                      style: AppTypography.sectionHeader,
                    ),
                    const SizedBox(height: 20),

                    // ── Full Name ────────────────────────────────────
                    AppTextField(
                      label: 'Full name',
                      hintText: 'e.g. Mujahid Amin',
                      prefixIcon: Icons.person_outline,
                      controller: _fullNameCtrl,
                    ),
                    const SizedBox(height: 20),

                    // ── Phone Number ────────────────────────────────
                    AppTextField(
                      label: 'Phone number',
                      hintText: 'e.g. +234 801 234 5678',
                      prefixIcon: Icons.phone_outlined,
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // ── Bio ─────────────────────────────────────────
                    AppTextField(
                      label: 'Bio',
                      hintText: 'Write a short bio about yourself',
                      prefixIcon: Icons.edit_outlined,
                      controller: _bioCtrl,
                      maxLines: 3,
                      optional: true,
                    ),
                    const SizedBox(height: 20),

                    // ── Location ────────────────────────────────────
                    AppTextField(
                      label: 'Location',
                      hintText: 'e.g. Lagos, Nigeria',
                      prefixIcon: Icons.location_on_outlined,
                      controller: _locationCtrl,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Bottom Button ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: AppButton(
                label: 'Complete Profile',
                loading: profileState.isLoading,
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
