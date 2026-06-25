import 'package:another_flushbar/flushbar.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/property/view/my_listings.dart';
import 'package:find_homes/features/property/view/property_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/widget/custom_text_field.dart';
import 'package:find_homes/features/auth/widget/social_button.dart';
import 'package:find_homes/features/auth/widget/role_selection_card.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isSignup = false;
  UserRole selectedRole = UserRole.client;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (isSignup) {
      ref
          .read(authNotifierProvider.notifier)
          .register(
            emailController.text,
            passwordController.text,
            selectedRole,
          );
    } else {
      ref
          .read(authNotifierProvider.notifier)
          .login(emailController.text, passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (previous, next) {
      final wasSubmitting = previous?.isLoading ?? false;
      if (!wasSubmitting || next.isLoading) return;

      if (next.hasError) {
        _showFlushbar(
          message: BackendError.extractMessage(next.error!),
          isError: true,
        );
        return;
      }

      if (next.hasValue && next.value != null) {
        _showFlushbar(
          message: isSignup
              ? 'Account created successfully.'
              : 'Signed in successfully.',
        );
        next.value?.role == UserRole.client
            ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const PropertyListings()),
                (_) => false,
              )
            : Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AgentListings()),
                (_) => false,
              );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.home_work,
                        color: AppColors.card,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'FindHomes',
                      style: AppTypography.heroPrice.copyWith(
                        color: AppColors.primary,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  isSignup ? 'Create an account' : 'Welcome back',
                  style: AppTypography.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  isSignup
                      ? 'Join us and find your dream home'
                      : 'Sign in to continue',
                  style: AppTypography.body.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 32),

                // Form Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (isSignup) ...[
                        RoleSelectionCard(
                          role: selectedRole,
                          onChanged: (role) {
                            setState(() {
                              selectedRole = role;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      CustomTextField(
                        label: 'Email Address',
                        hintText: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        controller: passwordController,
                        trailing: !isSignup
                            ? TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot password?',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: AppButton(
                          loading: authState.isLoading,
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          label: isSignup ? 'Sign up' : 'Sign in',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.divider),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.divider),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SocialButton(
                        label: 'Continue with Google',
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isSignup
                          ? 'Already have an account? '
                          : "Don't have an account? ",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSignup = !isSignup;
                        });
                      },
                      child: Text(
                        isSignup ? 'Sign in' : 'Sign up',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
