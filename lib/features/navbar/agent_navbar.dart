import 'package:find_homes/features/agent%20dashboard/view/agent_inquiries.dart';
import 'package:find_homes/features/navbar/navbar_ctrl.dart';
import 'package:find_homes/features/agent%20dashboard/view/my_listings.dart';
import 'package:find_homes/features/profile/view/agent_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgentNavbar extends ConsumerWidget {
  const AgentNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentScreen = ref.watch(currentScreenProvider);
    List<Widget> screens = [
      AgentListings(),
      AgentInquiriesScreen(),
      AgentProfileView(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: currentScreen,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen ?? 0,
        onDestinationSelected: (value) {
          navigateTo(ref, value);
        },
        destinations: const [
           NavigationDestination(
            selectedIcon: Icon(Icons.house_sharp),
            icon: Icon(Icons.house),
            label: 'My Listings',
          ),
           NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Inquiries',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ]
        ),
    );
  }
}


