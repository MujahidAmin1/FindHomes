import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/auth/controller/auth_controller.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:find_homes/features/chat/views/chat_list.dart';
import 'package:find_homes/features/profile/notifier/profile_notifier.dart';
import 'package:find_homes/features/property/notifier/property_notifier.dart';
import 'package:find_homes/features/property/view/property_detail.dart';
import 'package:find_homes/features/property/widgets/category_chips_bar.dart';
import 'package:find_homes/features/property/widgets/end_of_list_indicator.dart';
import 'package:find_homes/features/property/widgets/filter_bottom_sheet.dart';
import 'package:find_homes/features/property/widgets/property_card.dart';
import 'package:find_homes/features/property/widgets/property_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyListings extends ConsumerStatefulWidget {
  const PropertyListings({super.key});

  @override
  ConsumerState<PropertyListings> createState() => _PropertyListingsState();
}

class _PropertyListingsState extends ConsumerState<PropertyListings> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Eagerly fetch the user profile for the greeting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileNotifierProvider);
      if (!profile.hasValue || profile.value == null) {
        ref.read(profileNotifierProvider.notifier).fetchProfile();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Triggers the next page load when the user has scrolled ≥ 75%.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final threshold = position.maxScrollExtent * 0.75;
    if (position.pixels >= threshold) {
      ref.read(propertyNotifierProvider.notifier).loadNextPage();
    }
  }

  void _openFilterSheet() {
    final raw = ref.read(propertyNotifierProvider);
    final current = raw.value;
    FilterBottomSheet.show(
      context,
      currentListingType: current?.listingType,
      currentMinPrice: current?.minPrice,
      currentMaxPrice: current?.maxPrice,
      onApply: ({listingType, minPrice, maxPrice}) {
        ref.read(propertyNotifierProvider.notifier).applyFilters(
              listingType: listingType,
              minPrice: minPrice,
              maxPrice: maxPrice,
            );
      },
      onReset: () {
        ref.read(propertyNotifierProvider.notifier).clearFilters();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Redirect if logged out
    ref.listen(authNotifierProvider, (prev, next) {
      if (prev != null && next.hasValue && next.value == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (_) => false,
        );
      }
    });

    final asyncState = ref.watch(propertyNotifierProvider);
    final profile = ref.watch(profileNotifierProvider);
    final auth = ref.watch(authNotifierProvider);

    String greeting;
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    // Try profile fullName → fallback to email local part
    String? displayName;
    if (profile.hasValue && profile.value?.fullName != null) {
      displayName = profile.value!.fullName!.split(' ').first;
    } else if (auth.hasValue && auth.value != null) {
      displayName = auth.value!.email.split('@').first;
    }

    final stateData = asyncState.value;
    final selectedType = stateData?.selectedType;
    final hasActiveFilters = stateData?.hasActiveFilters ?? false;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName != null
                              ? '$greeting, $displayName 👋'
                              : '$greeting 👋',
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.muted),
                        ),
                        const SizedBox(height: 4),
                        Text('Explore Properties',
                            style: AppTypography.screenTitle),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatListScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 22,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            

            CategoryChipsBar(
              selectedType: selectedType,
              hasActiveFilters: hasActiveFilters,
              onTypeSelected: (type) {
                ref.read(propertyNotifierProvider.notifier).setPropertyType(type);
              },
              onFilterTap: () => _openFilterSheet(),
            ),
            const Divider(height: 1, color: AppColors.divider),
            

            Expanded(
              child: asyncState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => PropertyErrorState(
                  error: error,
                  onRetry: () => ref.invalidate(propertyNotifierProvider),
                ),
                data: (listState) {
                  final properties = listState.properties;

                  if (properties.isEmpty) {
                    return PropertyEmptyState(
                      onClearFilters: () => ref
                          .read(propertyNotifierProvider.notifier)
                          .clearFilters(),
                    );
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    itemCount: properties.length + 1,
                    separatorBuilder: (context2, index2) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == properties.length) {
                        return EndOfListIndicator(
                          isLoadingMore: listState.isLoadingMore,
                          hasReachedEnd: listState.hasReachedEnd,
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailScreen(
                                property: properties[index],
                              ),
                            ),
                          );
                        },
                        child: PropertyCard(property: properties[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}