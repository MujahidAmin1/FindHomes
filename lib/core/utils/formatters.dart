import 'package:intl/intl.dart';

class AppFormatters {
  static String formatCurrency(String price, String currency) {
    final currencyFormatter = NumberFormat.currency(
      symbol: currency == 'NGN' ? '₦' : currency,
      decimalDigits: 0,
    );
    return currencyFormatter.format(double.tryParse(price) ?? 0);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
