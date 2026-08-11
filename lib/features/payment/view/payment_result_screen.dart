import 'package:find_homes/core/theme/app_colors.dart';
import 'package:find_homes/core/theme/app_typography.dart';
import 'package:find_homes/core/utils/formatters.dart';
import 'package:find_homes/core/widgets/app_button.dart';
import 'package:find_homes/features/payment/model/payment.dart';
import 'package:find_homes/features/property/model/property.dart';
import 'package:flutter/material.dart';

class PaymentResultScreen extends StatefulWidget {
  final bool isSuccess;
  final String reference;
  final PropertyModel property;
  final PaymentRead? paymentRecord;
  final String? failureMessage;

  const PaymentResultScreen({
    super.key,
    required this.isSuccess,
    required this.reference,
    required this.property,
    this.paymentRecord,
    this.failureMessage,
  });

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.isSuccess;
    final statusColor = isSuccess ? AppColors.success : AppColors.error;
    final statusBg = isSuccess ? AppColors.successLight : AppColors.errorLight;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // ── Status Icon ───────────────────────────────────────────
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: statusBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSuccess
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 56,
                      color: statusColor,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Status Title ──────────────────────────────────────────
                Text(
                  isSuccess ? 'Payment Successful' : 'Payment Failed',
                  style: AppTypography.screenTitle.copyWith(color: statusColor),
                ),

                const SizedBox(height: 8),

                Text(
                  isSuccess
                      ? 'Your transaction has been completed successfully.'
                      : widget.failureMessage ??
                          'The payment could not be processed. Please try again.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(color: AppColors.muted),
                ),

                const SizedBox(height: 32),

                // ── Receipt Card ──────────────────────────────────────────
                _buildReceiptCard(statusColor),

                const SizedBox(height: 32),

                // ── Actions ───────────────────────────────────────────────
                AppButton(
                  label: isSuccess ? 'Back to Home' : 'Try Again',
                  onPressed: () {
                    // Pop back to the property detail (or home)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),

                const SizedBox(height: 12),

                if (isSuccess)
                  AppButton.outlined(
                    label: 'View Property',
                    onPressed: () {
                      // Pop just the result screen
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard(Color accentColor) {
    final property = widget.property;
    final record = widget.paymentRecord;
    final amount = record?.amount ?? property.price;
    final currency = record?.currency ?? property.currency;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.06),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded,
                    size: 20, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  'Transaction Receipt',
                  style: AppTypography.sectionHeader
                      .copyWith(color: accentColor),
                ),
              ],
            ),
          ),

          // ── Details ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _receiptRow('Property', property.title),
                _receiptRow('Location', property.locationText),
                _receiptRow('Type', property.propertyType.name.toUpperCase()),
                _receiptDivider(),
                _receiptRow(
                  'Amount',
                  AppFormatters.formatCurrency(
                    amount.toString(),
                    currency,
                  ),
                  valueBold: true,
                ),
                _receiptRow('Currency', currency.toUpperCase()),
                _receiptDivider(),
                _receiptRow('Reference', widget.reference, isMono: true),
                _receiptRow(
                  'Status',
                  _statusLabel,
                  valueColor: accentColor,
                ),
                if (record != null)
                  _receiptRow(
                    'Date',
                    AppFormatters.formatDate(record.createdAt),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _statusLabel {
    if (widget.paymentRecord != null) {
      return widget.paymentRecord!.status.toUpperCase();
    }
    return widget.isSuccess ? 'SUCCESS' : 'FAILED';
  }

  Widget _receiptRow(
    String label,
    String value, {
    bool valueBold = false,
    bool isMono = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: isMono
                  ? AppTypography.monoSmall.copyWith(
                      color: valueColor ?? AppColors.ink,
                    )
                  : (valueBold
                          ? AppTypography.bodyMedium
                          : AppTypography.body)
                      .copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiptDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(
          40,
          (_) => Expanded(
            child: Container(
              height: 1,
              color: AppColors.divider,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
