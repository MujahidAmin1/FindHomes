import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/agent%20dashboard/notifier/create_listing_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepDetailsPrice extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const StepDetailsPrice({super.key, required this.onNext});

  @override
  ConsumerState<StepDetailsPrice> createState() => _StepDetailsPriceState();
}

class _StepDetailsPriceState extends ConsumerState<StepDetailsPrice> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _sizeController;
  String _currency = 'NGN';
  int _bedrooms = 1;
  int _bathrooms = 1;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(createListingNotifierProvider);
    _priceController = TextEditingController(
      text: draft.price != null ? draft.price!.toStringAsFixed(2) : '',
    );
    _sizeController = TextEditingController(
      text: draft.sizeSqm != null ? draft.sizeSqm!.toStringAsFixed(0) : '',
    );
    _currency = draft.currency;
    _bedrooms = draft.bedrooms;
    _bathrooms = draft.bathrooms;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      ref.read(createListingNotifierProvider.notifier).updateStep2(
            currency: _currency,
            price: double.parse(_priceController.text.trim()),
            bedrooms: _bedrooms,
            bathrooms: _bathrooms,
            sizeSqm: _sizeController.text.trim().isNotEmpty
                ? double.tryParse(_sizeController.text.trim())
                : null,
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
                  Text('Property Details', style: AppTypography.displayLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Provide the key specifications and pricing for your listing.',
                    style:
                        AppTypography.body.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 32),

                  // ── Pricing ────────────────────────────────────────
                  Text(
                    'Pricing',
                    style: AppTypography.sectionHeader
                        .copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Currency selector
                      Container(
                        height: 52,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.divider,
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currency,
                            style: AppTypography.bodyMedium,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                size: 18),
                            items: const [
                              DropdownMenuItem(
                                value: 'NGN',
                                child: Text('NGN (₦)'),
                              ),
                              DropdownMenuItem(
                                value: 'USD',
                                child: Text('USD (\$)'),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _currency = v ?? 'NGN'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Price input
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                          style: AppTypography.body,
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: AppTypography.body.copyWith(
                              color:
                                  AppColors.muted.withValues(alpha: .5),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Price is required';
                            }
                            final price = double.tryParse(v.trim());
                            if (price == null || price <= 0) {
                              return 'Enter a valid price';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Specifications ─────────────────────────────────
                  Text(
                    'Specifications',
                    style: AppTypography.sectionHeader
                        .copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),

                  // Bedrooms stepper
                  _buildStepper(
                    icon: Icons.bed_outlined,
                    label: 'Bedrooms',
                    value: _bedrooms,
                    onChanged: (v) => setState(() => _bedrooms = v),
                  ),
                  const SizedBox(height: 12),

                  // Bathrooms stepper
                  _buildStepper(
                    icon: Icons.bathtub_outlined,
                    label: 'Bathrooms',
                    value: _bathrooms,
                    onChanged: (v) => setState(() => _bathrooms = v),
                  ),
                  const SizedBox(height: 24),

                  // ── Property Size ──────────────────────────────────
                  Text(
                    'Property Size',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _sizeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true),
                    style: AppTypography.body,
                    decoration: InputDecoration(
                      hintText: 'Enter size',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.muted.withValues(alpha: .5),
                      ),
                      suffixText: 'sqm',
                      suffixStyle: AppTypography.bodyMedium
                          .copyWith(color: AppColors.muted),
                    ),
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

  // ── Stepper row widget ──────────────────────────────────────────────────

  Widget _buildStepper({
    required IconData icon,
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted, size: 22),
          const SizedBox(width: 12),
          Text(label, style: AppTypography.bodyMedium),
          const Spacer(),
          _stepperButton(
            icon: Icons.remove,
            enabled: value > 0,
            onTap: () => onChanged(value - 1),
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: Text('$value', style: AppTypography.titleMedium),
            ),
          ),
          _stepperButton(
            icon: Icons.add,
            enabled: true,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppColors.muted : AppColors.divider,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.ink : AppColors.divider,
        ),
      ),
    );
  }
}
