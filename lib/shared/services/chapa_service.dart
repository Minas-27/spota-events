import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChapaService {
  static const String _baseUrl = 'https://api.chapa.co/v1';
  static const String _publicKey =
      'CHAPUBK_TEST-l33Kl0wzoCwiTjchl9X9cCmB3PWtuJGY';
  static const String _secretKey =
      'CHASECK_TEST-CiFYxzGBbsunuvvc1jEzb65pftnCotYo';

  /// Initialize a transaction
  /// Returns the checkout URL
  Future<String?> initializeTransaction({
    required String email,
    required String firstName,
    required String lastName,
    required double amount,
    required String txRef,
    required String title,
    String currency = 'ETB',
  }) async {
    final url = Uri.parse('$_baseUrl/transaction/initialize');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount.toString(),
          'currency': currency,
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'tx_ref': txRef,
          'callback_url':
              'https://checkout.chapa.co/checkout/payment-receipt/$txRef',
          'return_url':
              'https://example.com/payment-success', // We will intercept this
          'customization[title]': title,
          'customization[description]': 'Payment for $title',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data']['checkout_url'];
        }
      }

      debugPrint('Chapa Init Error: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Chapa Service Error: $e');
      return null;
    }
  }

  /// Verify a transaction
  Future<bool> verifyTransaction(String txRef) async {
    final url = Uri.parse('$_baseUrl/transaction/verify/$txRef');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_secretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }

      return false;
    } catch (e) {
      debugPrint('Chapa Verify Error: $e');
      return false;
    }
  }
}
