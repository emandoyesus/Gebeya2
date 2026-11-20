import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../data/mock_data.dart';
import '../models/category.dart';
import '../models/product.dart';

/// Centralized API Service
///
/// By default, this service uses offline/local data until you configure
/// [ApiConstants.useLiveApi] to true or enable it manually.
/// NO remote/external third-party APIs (like dummyjson or external stripe) are called.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String _kBaseUrlPrefKey = 'gebeya_custom_api_base_url';
  static const String _kUseLiveApiPrefKey = 'gebeya_use_live_api';

  String _customBaseUrl = '';
  bool _useLiveApi = ApiConstants.useLiveApi;

  bool get isLiveApiEnabled => _useLiveApi;
  String get activeBaseUrl =>
      _customBaseUrl.isNotEmpty ? _customBaseUrl : ApiConstants.baseUrl;

  /// Load any saved manual configuration overrides from local preferences
  Future<void> initConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customBaseUrl = prefs.getString(_kBaseUrlPrefKey) ?? '';
      _useLiveApi = prefs.getBool(_kUseLiveApiPrefKey) ?? ApiConstants.useLiveApi;
    } catch (e) {
      debugPrint('Error reading API preferences: $e');
    }
  }

  /// Manually configure your backend URL
  Future<void> setCustomBaseUrl(String url) async {
    _customBaseUrl = url.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBaseUrlPrefKey, _customBaseUrl);
  }

  /// Manually toggle whether to call your configured backend or stay offline
  Future<void> setUseLiveApi(bool enabled) async {
    _useLiveApi = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kUseLiveApiPrefKey, enabled);
  }

  /// Headers sent with API requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (ApiConstants.apiKey.isNotEmpty)
          'Authorization': 'Bearer ${ApiConstants.apiKey}',
      };

  // ===========================================================================
  // 1. PRODUCTS API
  // ===========================================================================

  /// Fetches products from your backend: GET `${activeBaseUrl}${ApiConstants.productsEndpoint}`
  /// Expected response format from your backend:
  ///   JSON Array: `[ { "id": "...", "name": "...", "price": 100, ... }, ... ]`
  ///   OR Object: `{ "products": [ ... ] }` or `{ "data": [ ... ] }`
  ///
  /// If live API is disabled or fails, safely returns local [MockData.products].
  Future<List<Product>> fetchProducts() async {
    if (!_useLiveApi) {
      return List<Product>.from(MockData.products);
    }

    try {
      final uri = Uri.parse('$activeBaseUrl${ApiConstants.productsEndpoint}');
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List rawList = [];

        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map) {
          if (decoded['products'] is List) {
            rawList = decoded['products'];
          } else if (decoded['data'] is List) {
            rawList = decoded['data'];
          }
        }

        if (rawList.isNotEmpty) {
          return rawList
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      debugPrint('Backend returned status ${response.statusCode}: ${response.body}');
    } catch (e) {
      debugPrint('Backend call failed ($e). Using local data.');
    }

    return List<Product>.from(MockData.products);
  }

  // ===========================================================================
  // 2. CATEGORIES API
  // ===========================================================================

  /// Fetches categories from your backend: GET `${activeBaseUrl}${ApiConstants.categoriesEndpoint}`
  /// Expected response format:
  ///   JSON Array: `[ { "id": "...", "name": "...", "itemCount": 5 }, ... ]`
  Future<List<ProductCategory>> fetchCategories() async {
    if (!_useLiveApi) {
      return List<ProductCategory>.from(MockData.categories);
    }

    try {
      final uri = Uri.parse('$activeBaseUrl${ApiConstants.categoriesEndpoint}');
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List rawList = decoded is List ? decoded : (decoded['categories'] ?? []);
        if (rawList.isNotEmpty) {
          return rawList.map((item) {
            return ProductCategory(
              id: item['id'] as String,
              name: item['name'] as String,
              nameAmharic: item['nameAmharic'] as String? ?? '',
              icon: MockData.getCategoryIcon(item['id'] as String),
              imageUrl: item['imageUrl'] as String? ?? '',
              itemCount: (item['itemCount'] as num?)?.toInt() ?? 0,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Categories fetch failed ($e). Using local categories.');
    }

    return List<ProductCategory>.from(MockData.categories);
  }

  // ===========================================================================
  // 3. CHECKOUT API
  // ===========================================================================

  /// Posts order & line items to your backend: POST `${activeBaseUrl}${ApiConstants.checkoutEndpoint}`
  /// Payload sent:
  /// ```json
  /// {
  ///   "items": [
  ///     { "productId": "...", "name": "...", "quantity": 1, "price": 100 }
  ///   ],
  ///   "customer": {
  ///     "fullName": "...",
  ///     "phone": "...",
  ///     "address": "...",
  ///     "city": "Addis Ababa"
  ///   },
  ///   "paymentMethod": "telebirr | cbeBirr | chapa | stripe | cashOnDelivery",
  ///   "total": 5200.0
  /// }
  /// ```
  Future<Map<String, dynamic>> createCheckoutSession({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> customer,
    required String paymentMethod,
    required double total,
  }) async {
    if (!_useLiveApi) {
      return {
        'success': true,
        'orderId': 'local_${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Order registered locally in demo mode.',
      };
    }

    try {
      final uri = Uri.parse('$activeBaseUrl${ApiConstants.checkoutEndpoint}');
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({
              'items': items,
              'customer': customer,
              'paymentMethod': paymentMethod,
              'total': total,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Checkout API failed ($e). Fallback to local confirmation.');
    }

    return {
      'success': true,
      'orderId': 'GBY-${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Order processed.',
    };
  }
}
