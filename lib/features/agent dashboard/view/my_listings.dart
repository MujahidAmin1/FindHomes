import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/agent%20dashboard/notifier/create_listing_notifier.dart';
import 'package:find_homes/features/agent%20dashboard/notifier/dashboard_notifier.dart';
import 'package:find_homes/features/agent%20dashboard/view/create_listing_screen.dart';
import 'package:find_homes/features/agent%20dashboard/widgets/agent_property_widget.dart';
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
    var dashboardState = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FindHomes",
          style: AppTypography.screenTitle.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Listings",
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text("Welcome Agent"),
            Expanded(
              child: dashboardState.when(
                data: (listings) {
                  if (listings.isEmpty) {
                    return Center(child: Text("No listings found"));
                  }
                  return ListView.builder(
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final propertylisting = listings[index];
                      return AgentPropertyWidget(property: propertylisting);
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (e, st) =>
                    Center(child: Text("Error loading listings, $e, $st")),
              ),
            ),

            FilledButton(
              onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(createListingNotifierProvider.notifier).reset();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateListingScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
