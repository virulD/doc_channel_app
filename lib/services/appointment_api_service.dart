import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentApiService {
  static const String _baseUrl = 'http://localhost:3000'; // Replace with your backend server IP or domain

  static Future<bool> saveAppointment(Map<String, dynamic> appointmentData) async {
    final url = Uri.parse('$_baseUrl/bookings');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointmentData),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to save appointment: \\${response.body}');
      return false;
    }
  }
} 