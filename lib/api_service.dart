// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "https://your-api-url.com/";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  Future<bool> sendOtp(String identifier) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier}), // Email or mobile
    );

    return response.statusCode == 200;
  }

  Future<bool> verifyOtp(String identifier, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier, 'otp': otp}),
    );

    return response.statusCode == 200;
  }
}
