import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgentProfileView extends ConsumerWidget {
  const AgentProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.value == null ) {
        // Navigate to the login screen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
        );
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Profile'),
      ),
      body: Center(
        child: AppButton(
          label: 'Logout',
          onPressed: () =>
            ref.read(authNotifierProvider.notifier).logout(),
          )
      ),
    );
  }
}