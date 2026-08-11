import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/property_extensions.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/payment/notifier/payment_notifier.dart';
import 'package:find_homes/features/payment/view/payment_result_screen.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyBottomBar extends ConsumerWidget {
  final PropertyModel property;

  const PropertyBottomBar({super.key, required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final paymentState = ref.watch(paymentNotifierProvider);

    // Listen for errors to show a snackbar
    ref.listen<PaymentState>(paymentNotifierProvider, (prev, next) {
      if (next.errorMessage != null && prev?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL PRICE',
                style: AppTypography.caption.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                property.formattedPrice,
                style: AppTypography.titleMedium.copyWith(fontSize: 22),
              ),
            ],
          ),

          SizedBox(
            width: 140,
            child: AppButton(
              label: _buttonLabel(paymentState.phase),
              loading: paymentState.isProcessing,
              onPressed: paymentState.isProcessing
                  ? null
                  : () => _handlePayment(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  String _buttonLabel(PaymentPhase phase) {
    return switch (phase) {
      PaymentPhase.idle => 'Pay Now',
      PaymentPhase.initializing => 'Starting…',
      PaymentPhase.checkingOut => 'Processing…',
      PaymentPhase.verifying => 'Verifying…',
    };
  }

  Future<void> _handlePayment(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(paymentNotifierProvider.notifier);

    final shouldNavigate = await notifier.processPayment(property.id);

    if (!shouldNavigate || !context.mounted) return;

    final state = ref.read(paymentNotifierProvider);
    final txResult = state.transactionResult;

    if (txResult == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentResultScreen(
          isSuccess: txResult.success,
          reference: state.initResponse?.reference ?? '',
          property: property,
          paymentRecord: state.paymentRecord,
          failureMessage: txResult.success ? null : txResult.message,
        ),
      ),
    );

    // Reset payment state after returning from result screen
    notifier.reset();
  }
}
