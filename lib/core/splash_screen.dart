import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/model/user.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:find_homes/features/property/view/my_listings.dart';
import 'package:find_homes/features/property/view/property_view.dart';
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

      final destination = next.hasValue && next.value != null
          ? (next.value!.role == UserRole.client
              ? const PropertyListings()
              : const AgentListings())
          : const AuthScreen();

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
