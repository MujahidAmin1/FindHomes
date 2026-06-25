import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgentListings extends ConsumerWidget {
  const AgentListings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (prev, next) {
      if (prev != null && next.hasValue && next.value == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (_) => false,
        );
      }
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Welcome Agent"),),
          FilledButton(
            onPressed: () =>  ref.read(authNotifierProvider.notifier).logout(), 
            child: Text("Logout"),
            )
        ],
      ),
    );
  }
}