import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AfroMessageService {
  static const String _baseUrl = 'https://api.afromessage.com/api/send';
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJpZGVudGlmaWVyIjoid0ZpN2J5a1JLeGlBWUxqWGNoak1ZSHNVZm5KZXRTV20iLCJleHAiOjE5MjAxMTIxMDYsImlhdCI6MTc2MjM0NTcwNiwianRpIjoiN2YzYmZmODEtMTI2Yi00MGY4LWFkM2MtY2UyNTJhZjc3MGU5In0.NigN9A4x92ZFK4_meCNl9KTlR_WPaR-48e6MHtvk2Rg';
  static const String _identifier = 'e80ad9d8-adf3-463f-80f4-7c4b39f7f164';

  /// Send ticket SMS
  Future<bool> sendTicketSMS({
    required String phoneNumber,
    required String eventTitle,
    required String ticketCode,
    required int ticketCount,
  }) async {
    try {
      // AfroMessage usually handles various formats, but +251 is safest.
      String formattedPhone = phoneNumber;
      if (formattedPhone.startsWith('0')) {
        formattedPhone = '+251${formattedPhone.substring(1)}';
      }

      final message = 'Your booking for $eventTitle is confirmed!\n'
          'Tickets: $ticketCount\n'
          'Code: $ticketCode\n'
          'Show this code at the entrance.\n'
          'Thank you for using SPOTA!';

      final requestBody = {
        'to': formattedPhone,
        'message': message,
        'from': _identifier,
      };

      debugPrint('--- AfroMessage SMS Request ---');
      debugPrint('URL: $_baseUrl');
      debugPrint('Payload: ${jsonEncode(requestBody)}');
      debugPrint('-------------------------------');

      final url = Uri.parse(_baseUrl);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('AfroMessage Response Code: ${response.statusCode}');
      debugPrint('AfroMessage Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success' || data['acknowledge'] == 'success';
      }

      if (kDebugMode &&
          response.statusCode == 401 &&
          response.body.toLowerCase().contains('balance')) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('AfroMessage Service Error: $e');
      return false;
    }
  }
}
