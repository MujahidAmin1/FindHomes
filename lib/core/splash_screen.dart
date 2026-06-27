import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:find_homes/features/navbar/agent_navbar.dart';
import 'package:find_homes/features/navbar/client_navbar.dart';
import 'package:find_homes/features/profile/view/agent_profile_update_view.dart';
import 'package:find_homes/features/profile/view/user_profile_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (prev, next) {
      if (next.isLoading) return;

      final Widget destination;

      if (next.hasValue && next.value != null) {
        final user = next.value!;

        if (user.onboardingStatus == OnboardingStatus.completed) {
          // Onboarding done → go to role-based navbar
          destination = user.role == UserRole.client
              ? const ClientNavbar()
              : const AgentNavbar();
        } else {
          // Onboarding incomplete → resume the flow
          if (user.role == UserRole.agent &&
              user.onboardingStatus == OnboardingStatus.in_progress) {
            // Agent who finished user profile but not agent profile
            destination = const AgentProfileUpdateView();
          } else {
            destination = const UserProfileUpdate();
          }
        }
      } else {
        destination = const AuthScreen();
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => destination),
        (_) => false,
      );
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work,
              size: 80,
              color: AppColors.card,
            ),
            SizedBox(height: 24),
            Text(
              "FindHomes",
              style: TextStyle(
                color: AppColors.card,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.card),
            ),
          ],
        ),
      ),
    );
  }
}
