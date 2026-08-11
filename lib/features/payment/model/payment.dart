
class PaymentInitializeResponse {
  final String accessCode;
  final String reference;

  PaymentInitializeResponse({
    required this.accessCode,
    required this.reference,
  });

  factory PaymentInitializeResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitializeResponse(
      accessCode: json['access_code'] as String,
      reference: json['reference'] as String,
    );
  }
}

/// Wraps the result returned by the Paystack Flutter SDK after the user
/// completes (or cancels) the checkout flow.
class PaystackTransactionResult {
  /// `true` when the transaction completed successfully.
  final bool success;

  /// Human-readable message from the SDK (e.g. "Transaction successful").
  final String message;

  /// Unique transaction reference – only populated when [success] is `true`.
  final String? reference;

  PaystackTransactionResult({
    required this.success,
    required this.message,
    this.reference,
  });
}

/// Full payment record returned by `GET /payments/{reference}`.
class PaymentRead {
  final String id;
  final String userId;
  final String propertyId;
  final String reference;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentRead({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.reference,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentRead.fromJson(Map<String, dynamic> json) {
    return PaymentRead(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      propertyId: json['property_id'] as String,
      reference: json['reference'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Whether the backend has confirmed this payment as successful
  /// (i.e. webhook was verified).
  bool get isSuccess => status == 'success';

  /// Whether the payment is still awaiting webhook verification.
  bool get isPending => status == 'pending';
}