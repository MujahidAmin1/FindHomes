import 'package:find_homes/features/favourites/views/favourites_view.dart';
import 'package:find_homes/features/navbar/navbar_ctrl.dart';
import 'package:find_homes/features/profile/view/user_profile_view.dart';
import 'package:find_homes/features/property/view/property_view.dart';
import 'package:find_homes/features/search/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientNavbar extends ConsumerWidget {
  const ClientNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentScreen = ref.watch(currentScreenProvider);
    List<Widget> screens = [
      PropertyListings(),
      SearchView(),
      FavouritesView(),
      UserProfileView()
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
            label: 'Home',
          ),
           NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
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


