import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost:3000";

  Future<void> createAccount(String email, String password, String fullName, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<void> updateAccountSettings(String uid, String email, String fullName, String phoneNumber) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/account-settings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': uid, 'email': email, 'fullName': fullName, 'phoneNumber': phoneNumber}),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
