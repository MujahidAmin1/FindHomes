import 'package:dio/dio.dart';
import 'package:find_homes/core/endpoints.dart';
import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/utils/app_logger.dart';
import 'package:find_homes/core/utils/backend_error.dart';
import 'package:find_homes/features/payment/model/payment.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';

class PaymentService {
  final String _tag = 'PaymentService';
  final Dio _dio = serviceLocator.get<Dio>();

  final Paystack _paystack = Paystack();
  bool _sdkInitialized = false;

  Future<void> _ensureSdkInitialized() async {
    if (_sdkInitialized) return;

    final publicKey = dotenv.env['PAYSTACK_PUBLIC_KEY'];
    if (publicKey == null || publicKey.isEmpty) {
      throw const BackendException(
        'PAYSTACK_PUBLIC_KEY is not set in .env',
      );
    }

    try {
      AppLogger.d('Initializing Paystack SDK…', tag: _tag);
      final result = await _paystack.initialize(publicKey, true);

      if (result) {
        _sdkInitialized = true;
        AppLogger.i('Paystack SDK initialized successfully', tag: _tag);
      } else {
        throw const BackendException('Failed to initialize Paystack SDK');
      }
    } on PlatformException catch (e) {
      AppLogger.e(
        'Paystack SDK initialization failed: ${e.message}',
        tag: _tag,
        error: e,
      );
      throw BackendException(
        e.message ?? 'Failed to initialize Paystack SDK',
      );
    }
  }

  // ── 1. Initialize Payment ────────────────────────────────────────────────

  /// Calls `POST /payments/initialize` with the given [propertyId].
  ///
  /// Returns a [PaymentInitializeResponse] containing the `accessCode`
  /// (needed to launch checkout) and the `reference` (needed to query status).
  Future<PaymentInitializeResponse> initializePayment(
    String propertyId,
  ) async {
    try {
      AppLogger.d(
        'POST /payments/initialize  propertyId=$propertyId',
        tag: _tag,
      );

      final response = await _dio.post(
        Endpoints.initializePayment,
        queryParameters: {'property_id': propertyId},
      );

      final data = response.data as Map<String, dynamic>;
      return PaymentInitializeResponse.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e(
        'initializePayment failed | status=${e.response?.statusCode} '
        '| data=${e.response?.data} | dioMsg=${e.message}',
        tag: _tag,
        error: e,
      );
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to initialize payment',
      );
    }
  }

  // ── 2. Launch Paystack Checkout ──────────────────────────────────────────

  /// Opens the native Paystack checkout UI using the [accessCode] obtained
  /// from [initializePayment].
  ///
  /// Returns a [PaystackTransactionResult] indicating whether the payment
  /// succeeded, was cancelled, or failed.
  Future<PaystackTransactionResult> launchPaystackCheckout(
    String accessCode,
  ) async {
    await _ensureSdkInitialized();

    try {
      AppLogger.d('Launching Paystack checkout…', tag: _tag);
      final response = await _paystack.launch(accessCode);

      if (response.status == "success") {
        AppLogger.i(
          'Payment successful — ref: ${response.reference}',
          tag: _tag,
        );
        return PaystackTransactionResult(
          success: true,
          message: response.message,
          reference: response.reference,
        );
      } else {
        AppLogger.w(
          'Payment not successful — ${response.message}',
          tag: _tag,
        );
        return PaystackTransactionResult(
          success: false,
          message: response.message,
        );
      }
    } on PlatformException catch (e) {
      AppLogger.e(
        'Paystack checkout error: ${e.message}',
        tag: _tag,
        error: e,
      );
      return PaystackTransactionResult(
        success: false,
        message: e.message ?? 'Payment checkout failed',
      );
    }
  }

  // ── 3. Get Payment Status ────────────────────────────────────────────────

  /// Fetches the payment record from the backend via
  /// `GET /payments/{reference}`.
  ///
  /// Use this after a successful checkout to confirm the webhook has verified
  /// the payment on the server side.
  Future<PaymentRead> getPaymentStatus(String reference) async {
    try {
      AppLogger.d('GET /payments/$reference', tag: _tag);

      final response = await _dio.get(
        Endpoints.getPaymentStatus(reference),
      );

      final data = response.data as Map<String, dynamic>;
      return PaymentRead.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e(
        'getPaymentStatus failed | status=${e.response?.statusCode} '
        '| data=${e.response?.data} | dioMsg=${e.message}',
        tag: _tag,
        error: e,
      );
      throw BackendException.fromDioException(
        e,
        fallbackMessage: 'Failed to fetch payment status',
      );
    }
  }
}