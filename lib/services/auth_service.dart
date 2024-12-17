import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://localhost:3000/auth";

class AuthService {
  static Future<Map<String, dynamic>> signUp(String email, String password, String fullName, String phoneNumber) async {
    final url = Uri.parse("$baseUrl/signup");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
      }),
    );

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse("$baseUrl/forgot-password");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> updateAccountSettings(String uid, String email, String fullName, String phoneNumber) async {
    final url = Uri.parse("$baseUrl/account-settings");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "uid": uid,
        "email": email,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
      }),
    );

    return _processResponse(response);
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"success": true, "data": responseBody};
    } else {
      return {"success": false, "error": responseBody['error']};
    }
  }
}
