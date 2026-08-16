import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://vimark-api-prod.onrender.com';

  // =========================
  // TOKEN / SESSION
  // =========================

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

  // =========================
  // HEALTH
  // =========================

  static Future<Map<String, dynamic>> health() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/health'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Erreur API: ${response.statusCode}',
    );
  }

  // =========================
  // REGISTER
  // =========================

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
      data['error'] ??
          'Erreur lors de l inscription',
    );
  }

  // =========================
  // LOGIN
  // =========================

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
      data['error'] ??
          'Identifiants incorrects',
    );
  }

  // =========================
  // CURRENT USER
  // =========================

  static Future<Map<String, dynamic>> getMe() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
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
      data['error'] ??
          'Impossible de récupérer votre profil',
    );
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  static Future<Map<String, dynamic>> updateMe({
    required String name,
    String? phone,
    String? email,
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.put(
      Uri.parse('$baseUrl/api/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de modifier votre profil',
    );
  }

  // =========================
  // BUSINESS - CREATE
  // =========================

  static Future<Map<String, dynamic>> createBusiness({
    required String name,
    String description = '',
    String location = '',
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/businesses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'location': location,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de créer la boutique',
    );
  }

  // =========================
  // BUSINESS - MY STORE
  // =========================

  static Future<Map<String, dynamic>> getMyBusiness() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/businesses/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de récupérer votre boutique',
    );
  }

  // =========================
  // BUSINESS - UPDATE
  // =========================

  static Future<Map<String, dynamic>> updateBusiness({
    required String name,
    String description = '',
    String location = '',
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.put(
      Uri.parse('$baseUrl/api/businesses/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'location': location,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de modifier la boutique',
    );
  }

  // =========================
  // PRODUCTS - PUBLIC
  // =========================

  static Future<List<dynamic>> getProducts({
    String? search,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/products',
    ).replace(
      queryParameters:
          search != null && search.isNotEmpty
              ? {'search': search}
              : {},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Impossible de charger les produits',
    );
  }

  // =========================
  // PRODUCTS - MY PRODUCTS
  // =========================

  static Future<List<dynamic>> getMyProducts() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/products/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de récupérer vos produits',
    );
  }

  // =========================
  // PRODUCT - CREATE
  // =========================

  static Future<Map<String, dynamic>> createProduct({
    required int businessId,
    required String name,
    String description = '',
    required int price,
    String imageUrl = '',
    int stock = 0,
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'business_id': businessId,
        'name': name,
        'description': description,
        'price': price,
        'image_url': imageUrl,
        'stock': stock,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de créer le produit',
    );
  }

  // =========================
  // PRODUCT - UPDATE
  // =========================

  static Future<Map<String, dynamic>> updateProduct({
    required int productId,
    required String name,
    String description = '',
    required int price,
    String imageUrl = '',
    int stock = 0,
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.put(
      Uri.parse(
        '$baseUrl/api/products/$productId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'image_url': imageUrl,
        'stock': stock,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de modifier le produit',
    );
  }

  // =========================
  // PRODUCT - DELETE
  // =========================

  static Future<void> deleteProduct({
    required int productId,
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.delete(
      Uri.parse(
        '$baseUrl/api/products/$productId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    final data = jsonDecode(response.body);

    throw Exception(
      data['error'] ??
          'Impossible de supprimer le produit',
    );
  }

  // =========================
  // COURSES
  // =========================

  static Future<List<dynamic>> getCourses({
    String? subject,
    String? level,
  }) async {
    final query = <String, String>{};

    if (subject != null &&
        subject.isNotEmpty) {
      query['subject'] = subject;
    }

    if (level != null &&
        level.isNotEmpty) {
      query['level'] = level;
    }

    final uri = Uri.parse(
      '$baseUrl/api/courses',
    ).replace(
      queryParameters: query,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Impossible de charger les cours',
    );
  }

  // =========================
  // SUBSCRIPTIONS
  // =========================

  static Future<Map<String, dynamic>>
      createSubscription({
    String plan = 'premium',
    int amount = 1500,
  }) async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/subscriptions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'plan': plan,
        'amount': amount,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de créer l abonnement',
    );
  }

  static Future<List<dynamic>>
      getMySubscriptions() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Session utilisateur introuvable',
      );
    }

    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/subscriptions/me',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['error'] ??
          'Impossible de récupérer les abonnements',
    );
  }
}
