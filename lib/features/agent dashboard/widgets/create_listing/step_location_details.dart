import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/agent%20dashboard/notifier/create_listing_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepLocationDetails extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const StepLocationDetails({super.key, required this.onNext});

  @override
  ConsumerState<StepLocationDetails> createState() =>
      _StepLocationDetailsState();
}

class _StepLocationDetailsState extends ConsumerState<StepLocationDetails> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _locationController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(createListingNotifierProvider);
    _locationController = TextEditingController(text: draft.location);
    _latitudeController = TextEditingController(
      text: draft.latitude?.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: draft.longitude?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      ref.read(createListingNotifierProvider.notifier).updateStep3(
            location: _locationController.text.trim(),
            latitude:
                double.tryParse(_latitudeController.text.trim()),
            longitude:
                double.tryParse(_longitudeController.text.trim()),
          );
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  Text(
                    'Location details',
                    style: AppTypography.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pinpoint the exact location of your property to help buyers find it easily.',
                    style:
                        AppTypography.body.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 32),

                  // ── Location ───────────────────────────────────────
                  Text(
                    'Location',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _locationController,
                    style: AppTypography.body,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Wuse 2, Abuja',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.muted.withValues(alpha: .5),
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.muted,
                        size: 20,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Location is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Latitude & Longitude ───────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latitude',
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.muted),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _latitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                              style: AppTypography.body,
                              decoration: InputDecoration(
                                hintText: '6.5244',
                                hintStyle: AppTypography.body.copyWith(
                                  color: AppColors.muted
                                      .withValues(alpha: .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Longitude',
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.muted),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _longitudeController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                              style: AppTypography.body,
                              decoration: InputDecoration(
                                hintText: '3.3792',
                                hintStyle: AppTypography.body.copyWith(
                                  color: AppColors.muted
                                      .withValues(alpha: .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),

        // ── Bottom Button ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: AppButton(
            label: 'Next Step',
            onPressed: _onNext,
            trailing: const Icon(Icons.arrow_forward,
                color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}
