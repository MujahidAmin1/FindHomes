import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/agent%20dashboard/notifier/create_listing_notifier.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepBasicDetails extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const StepBasicDetails({super.key, required this.onNext});

  @override
  ConsumerState<StepBasicDetails> createState() => _StepBasicDetailsState();
}

class _StepBasicDetailsState extends ConsumerState<StepBasicDetails> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  PropertyType? _propertyType;
  ListingType? _listingType;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(createListingNotifierProvider);
    _titleController = TextEditingController(text: draft.title);
    _descriptionController = TextEditingController(text: draft.description);
    _propertyType = draft.propertyType;
    _listingType = draft.listingType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      ref.read(createListingNotifierProvider.notifier).updateStep1(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            propertyType: _propertyType!,
            listingType: _listingType!,
          );
      widget.onNext();
    }
  }

  String _displayName(Enum value) {
    if (value == ListingType.sale) return 'For Sale';
    if (value == ListingType.rent) return 'For Rent';
    final name = value.name;
    return name[0].toUpperCase() + name.substring(1);
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
                  Text('Listing Basics', style: AppTypography.displayLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Provide the foundational details for your new property listing.',
                    style:
                        AppTypography.body.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 32),

                  // ── Property Title ─────────────────────────────────
                  Text(
                    'Property Title',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    style: AppTypography.body,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText:
                          'e.g., Luxury 4-Bedroom Duplex in Lekki',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.muted.withValues(alpha: .5),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Title is required';
                      }
                      if (v.trim().length < 5) {
                        return 'Title must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Description ────────────────────────────────────
                  Text(
                    'Description',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    style: AppTypography.body,
                    maxLines: 4,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText:
                          'Highlight the key features and selling points...',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.muted.withValues(alpha: .5),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Description is required';
                      }
                      if (v.trim().length < 20) {
                        return 'Description must be at least 20 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Property Type ──────────────────────────────────
                  Text(
                    'Property Type',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<PropertyType>(
                    initialValue: _propertyType,
                    decoration: InputDecoration(
                      hintText: 'Select Property Type',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.muted.withValues(alpha: .5),
                      ),
                    ),
                    style: AppTypography.body,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.muted),
                    items: PropertyType.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(_displayName(t)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _propertyType = v),
                    validator: (v) =>
                        v == null ? 'Please select a property type' : null,
                  ),
                  const SizedBox(height: 24),

                  // ── Listing Type ───────────────────────────────────
                  Text(
                    'Listing Type',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ListingType>(
                    initialValue: _listingType,
                    decoration: InputDecoration(
                      hintText: 'Select Listing Type',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.muted.withValues(alpha: .5),
                      ),
                    ),
                    style: AppTypography.body,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.muted),
                    items: ListingType.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(_displayName(t)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _listingType = v),
                    validator: (v) =>
                        v == null ? 'Please select a listing type' : null,
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
