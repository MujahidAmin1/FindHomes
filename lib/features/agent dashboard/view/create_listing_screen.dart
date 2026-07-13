import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/features/agent%20dashboard/widgets/create_listing/step_basic_details.dart';
import 'package:find_homes/features/agent%20dashboard/widgets/create_listing/step_details_price.dart';
import 'package:find_homes/features/agent%20dashboard/widgets/create_listing/step_indicator.dart';
import 'package:find_homes/features/agent%20dashboard/widgets/create_listing/step_location_details.dart';
import 'package:find_homes/features/agent%20dashboard/widgets/create_listing/step_photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Multi-step listing creation screen.
///
/// Owns the [PageController], step indicator, and AppBar navigation.
/// Each step manages its own form; the notifier is only updated on "Next".
class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _pageController = PageController();
  final _stepPhotosKey = GlobalKey<StepPhotosState>();
  int _currentStep = 0;

  static const _stepTitles = [
    'Basic Details',
    'Details & Price',
    'Location',
    'Photos',
  ];

  // ── Navigation helpers ──────────────────────────────────────────────────

  void _goToNext() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _goToPrevious() {
    if (_currentStep == 0) {
      Navigator.of(context).pop();
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _goToPrevious,
        ),
        centerTitle: true,
        title: Text('Create Listing', style: AppTypography.bodyMedium),
        actions: [
          if (_currentStep == 3)
            TextButton(
              onPressed: () => _stepPhotosKey.currentState?.submit(),
              child: Text(
                'Save',
                style: AppTypography.buttonLabel
                    .copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          StepIndicator(
            currentStep: _currentStep,
            totalSteps: 4,
            stepTitles: _stepTitles,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StepBasicDetails(onNext: _goToNext),
                StepDetailsPrice(onNext: _goToNext),
                StepLocationDetails(onNext: _goToNext),
                StepPhotos(key: _stepPhotosKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
