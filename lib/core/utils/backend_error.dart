import 'dart:convert';

import 'package:dio/dio.dart';

class BackendException implements Exception {
  const BackendException(this.message);

  factory BackendException.fromDioException(
    DioException exception, {
    String fallbackMessage = 'Something went wrong. Please try again.',
  }) {
    return BackendException(
      BackendError.extractMessage(exception, fallbackMessage: fallbackMessage),
    );
  }

  final String message;

  @override
  String toString() => message;
}

abstract final class BackendError {
  static String extractMessage(
    Object error, {
    String fallbackMessage = 'Something went wrong. Please try again.',
  }) {
    if (error is BackendException) return error.message;

    if (error is DioException) {
      final detail = _detailFromData(error.response?.data);
      if (detail != null) return detail;

      final dioMessage = error.message;
      if (dioMessage != null && dioMessage.trim().isNotEmpty) {
        return dioMessage;
      }
    }

    final message = error.toString().replaceFirst('Exception: ', '').trim();
    return message.isEmpty ? fallbackMessage : message;
  }

  static String? _detailFromData(Object? data) {
    if (data is Map<String, dynamic>) return _detailValue(data['detail']);
    if (data is Map) return _detailValue(data['detail']);

    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return _detailValue(decoded['detail']);
      } on FormatException {
        return data;
      }
    }

    return null;
  }

  static String? _detailValue(Object? detail) {
    if (detail is String && detail.trim().isNotEmpty) return detail;
    return null;
  }
}
