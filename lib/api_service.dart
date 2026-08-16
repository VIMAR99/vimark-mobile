import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://vimark-api-prod.onrender.com';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vimark_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('vimark_token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('vimark_token');
  }

  static Future<Map<String, dynamic>> health() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/health'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Erreur API: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    String? phone,
    String? email,
    required String password,
    String role = 'student',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      return data;
    }

    throw Exception(
      data['error'] ?? 'Erreur lors de l inscription',
    );
  }

  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      return data;
    }

    throw Exception(
      data['error'] ?? 'Identifiants incorrects',
    );
  }

  static Future<Map<String, dynamic>> getMe() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Session utilisateur introuvable');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['error'] ?? 'Impossible de récupérer votre profil',
    );
  }

  static Future<List<dynamic>> getCourses({
    String? subject,
    String? level,
  }) async {
    final query = <String, String>{};

    if (subject != null && subject.isNotEmpty) {
      query['subject'] = subject;
    }

    if (level != null && level.isNotEmpty) {
      query['level'] = level;
    }

    final uri = Uri.parse(
      '$baseUrl/api/courses',
    ).replace(queryParameters: query);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Impossible de charger les cours');
  }

  static Future<List<dynamic>> getProducts({
    String? search,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/products',
    ).replace(
      queryParameters: search != null && search.isNotEmpty
          ? {'search': search}
          : {},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Impossible de charger les produits');
  }
}
