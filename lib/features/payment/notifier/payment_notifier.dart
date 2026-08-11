import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/payment/model/payment.dart';
import 'package:find_homes/features/payment/service/payment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum PaymentPhase { idle, initializing, checkingOut, verifying }

class PaymentState {
  final PaymentPhase phase;
  final String? errorMessage;
  final PaymentInitializeResponse? initResponse;
  final PaystackTransactionResult? transactionResult;
  final PaymentRead? paymentRecord;

  const PaymentState({
    this.phase = PaymentPhase.idle,
    this.errorMessage,
    this.initResponse,
    this.transactionResult,
    this.paymentRecord,
  });

  bool get isProcessing => phase != PaymentPhase.idle;

  PaymentState copyWith({
    PaymentPhase? phase,
    String? errorMessage,
    PaymentInitializeResponse? initResponse,
    PaystackTransactionResult? transactionResult,
    PaymentRead? paymentRecord,
  }) {
    return PaymentState(
      phase: phase ?? this.phase,
      errorMessage: errorMessage,
      initResponse: initResponse ?? this.initResponse,
      transactionResult: transactionResult ?? this.transactionResult,
      paymentRecord: paymentRecord ?? this.paymentRecord,
    );
  }
}


final paymentNotifierProvider =
    NotifierProvider<PaymentNotifier, PaymentState>(PaymentNotifier.new);

class PaymentNotifier extends Notifier<PaymentState> {
  PaymentService get _service => serviceLocator.get<PaymentService>();

  @override
  PaymentState build() => const PaymentState();

  /// Runs the full payment flow: initialize → checkout → verify.
  ///
  /// Returns `true` if the Paystack checkout completed (success or fail),
  /// so the caller knows to navigate to the result screen.
  /// Returns `false` if we couldn't even launch checkout (e.g. network error).
  Future<bool> processPayment(String propertyId) async {
    // ── 1. Initialize ────────────────────────────────────────────────────
    state = const PaymentState(phase: PaymentPhase.initializing);

    final PaymentInitializeResponse initResponse;
    try {
      initResponse = await _service.initializePayment(propertyId);
    } catch (e) {
      state = PaymentState(
        phase: PaymentPhase.idle,
        errorMessage: BackendError.extractMessage(e),
      );
      return false;
    }

    // ── 2. Launch Checkout ───────────────────────────────────────────────
    state = PaymentState(
      phase: PaymentPhase.checkingOut,
      initResponse: initResponse,
    );

    final PaystackTransactionResult txResult;
    try {
      txResult = await _service.launchPaystackCheckout(initResponse.accessCode);
    } catch (e) {
      state = PaymentState(
        phase: PaymentPhase.idle,
        errorMessage: BackendError.extractMessage(e),
        initResponse: initResponse,
      );
      return false;
    }

    // ── 3. Verify on backend (only if SDK said success) ─────────────────
    if (txResult.success) {
      state = PaymentState(
        phase: PaymentPhase.verifying,
        initResponse: initResponse,
        transactionResult: txResult,
      );

      try {
        final record = await _service.getPaymentStatus(
          initResponse.reference,
        );
        state = PaymentState(
          phase: PaymentPhase.idle,
          initResponse: initResponse,
          transactionResult: txResult,
          paymentRecord: record,
        );
      } catch (_) {
        // Verification fetch failed but Paystack said success —
        // still show the result screen with SDK data.
        state = PaymentState(
          phase: PaymentPhase.idle,
          initResponse: initResponse,
          transactionResult: txResult,
        );
      }
    } else {
      state = PaymentState(
        phase: PaymentPhase.idle,
        initResponse: initResponse,
        transactionResult: txResult,
      );
    }

    return true;
  }

  /// Resets the notifier to its idle state.
  void reset() => state = const PaymentState();
}
