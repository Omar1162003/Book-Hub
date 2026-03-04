// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/book.dart';

class ApiService {
  static const String baseUrl =
      'https://dawn-knobbiest-statistically.ngrok-free.dev/api';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };

  static Future<User?> register(
      String name, String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/User/register');

      print('=== Register Request ===');
      print('URL: $url');
      print('Name: $name');
      print('Email: $email');

      final body = jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      });
      print('Request body: $body');
      print('Headers: $_headers');

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      print('=== Register Response ===');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('========================');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        // حاول نقرأ رسالة الخطأ من الـ response
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['message'] != null) {
            print('Error message: ${errorData['message']}');
          }
        } catch (e) {
          // لو مش قادر نقرأ JSON، استخدم response.body كامل
          print('Raw error response: ${response.body}');
        }

        print('Registration failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Register exception: $e');
      return null;
    }
  }

  static Future<User?> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/User/login');

      print('=== Login Request ===');
      print('URL: $url');
      print('Email: $email');

      final body = jsonEncode({
        'email': email,
        'password': password,
      });
      print('Request body: $body');

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      print('=== Login Response ===');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('======================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login exception: $e');
      return null;
    }
  }

  static Future<List<Book>> fetchBooks() async {
    try {
      final url = Uri.parse('$baseUrl/Books');

      final response = await http.get(
        url,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Fetch books exception: $e');
      return [];
    }
  }

  static Future<bool> checkoutBook(String userId, String bookId) async {
    try {
      final url = Uri.parse('$baseUrl/Books/checkout');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'userId': userId,
          'bookId': bookId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Checkout exception: $e');
      return false;
    }
  }

  static Future<bool> returnBook(String userId, String bookId) async {
    try {
      final url = Uri.parse('$baseUrl/Books/return');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'userId': userId,
          'bookId': bookId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Return exception: $e');
      return false;
    }
  }
}
