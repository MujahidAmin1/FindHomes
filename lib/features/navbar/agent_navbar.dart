import 'package:find_homes/features/navbar/navbar_ctrl.dart';
import 'package:find_homes/features/property/view/my_listings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgentNavbar extends ConsumerWidget {
  const AgentNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentScreen = ref.watch(currentScreenProvider);
    List<Widget> screens = [
    AgentListings()
    //  UpcomingAnimeView(),
    //  SearchScreen()
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
            selectedIcon: Icon(Icons.play_circle),
            icon: Icon(Icons.play_circle_outline),
            label: 'Ongoing',
          ),
           NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Upcoming',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
        ]
        ),
    );
  }
}


