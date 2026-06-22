import 'package:find_homes/core/utils/sizing_utils.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:find_homes/features/property/view/property_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (prev, next) {
      if (next.isLoading) return;
      final destination =
          next.hasValue && next.value != null ? const PropertyListings() : const AuthScreen();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => destination),
        (_) => false,
      );
    });

    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/app_icon",
              scale: 1.0,
            ),
            addHorizontalSpacing(10),
            Text("FindHomes", style: TextTheme.of(context).displayLarge),
            addHorizontalSpacing(10),
            Text("FindHomes", style: TextTheme.of(context).displayMedium),
          ],
        ),
      )
      );
  }
}