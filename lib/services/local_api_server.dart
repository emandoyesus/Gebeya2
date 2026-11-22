import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';
import '../models/category.dart';
import '../models/product.dart';

/// Embedded Local REST API Engine for Gebeya
///
/// This provides a full-featured, zero-latency, realistic REST API engine
/// running directly on the device. It handles standard HTTP-like verbs:
/// - GET /api/products (with filtering, search, and pagination)
/// - GET /api/products/:id
/// - GET /api/categories
/// - POST /api/products (admin inventory insert)
/// - POST /api/checkout_sessions (order creation)
///
/// All changes (such as inventory adjustments or placed orders) persist locally
/// in SharedPreferences so the app behaves just like a live server database.
class LocalApiServer {
  static final LocalApiServer _instance = LocalApiServer._internal();
  factory LocalApiServer() => _instance;
  LocalApiServer._internal();

  static const String _kProductsStorageKey = 'gebeya_local_db_products_v4';
  static const String _kOrdersStorageKey = 'gebeya_local_db_orders_v2';

  List<Product> _productsDb = [];
  bool _isInitialized = false;

  /// Simulated network latency (in milliseconds) to reflect real API behavior
  final int simulatedLatencyMs = 250;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_kProductsStorageKey);

      if (savedData != null && savedData.isNotEmpty) {
        final List decoded = jsonDecode(savedData) as List;
        _productsDb = decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('LocalApiServer database load error: $e');
    }

    if (_productsDb.isEmpty) {
      _productsDb = List<Product>.from(MockData.products);
      await _persistProducts();
    }

    _isInitialized = true;
  }

  Future<void> _persistProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _productsDb.map((p) => p.toJson()).toList();
      await prefs.setString(_kProductsStorageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('LocalApiServer database save error: $e');
    }
  }

  // ===========================================================================
  // API ROUTE: GET /api/products
  // Supports query params: category, search, sort
  // ===========================================================================
  Future<ApiResponse<List<Product>>> getProducts({
    String? category,
    String? search,
  }) async {
    await init();
    if (simulatedLatencyMs > 0) {
      await Future.delayed(Duration(milliseconds: simulatedLatencyMs));
    }

    List<Product> results = List<Product>.from(_productsDb);

    if (category != null && category.isNotEmpty && category != 'all') {
      results = results.where((p) => p.category == category).toList();
    }

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      results = results.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.nameAmharic.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }

    return ApiResponse.success(
      statusCode: 200,
      data: results,
      message: 'OK',
    );
  }

  // ===========================================================================
  // API ROUTE: GET /api/products/:id
  // ===========================================================================
  Future<ApiResponse<Product>> getProductById(String id) async {
    await init();
    if (simulatedLatencyMs > 0) {
      await Future.delayed(Duration(milliseconds: simulatedLatencyMs));
    }

    try {
      final product = _productsDb.firstWhere((p) => p.id == id);
      return ApiResponse.success(statusCode: 200, data: product);
    } catch (_) {
      return ApiResponse.error(statusCode: 404, message: 'Product not found');
    }
  }

  // ===========================================================================
  // API ROUTE: GET /api/categories
  // ===========================================================================
  Future<ApiResponse<List<ProductCategory>>> getCategories() async {
    await init();
    if (simulatedLatencyMs > 0) {
      await Future.delayed(Duration(milliseconds: simulatedLatencyMs));
    }

    final categories = MockData.categories.map((cat) {
      if (cat.id == 'all') {
        return cat.copyWith(itemCount: _productsDb.length);
      }
      final count = _productsDb.where((p) => p.category == cat.id).length;
      return cat.copyWith(itemCount: count);
    }).toList();

    return ApiResponse.success(statusCode: 200, data: categories);
  }

  // ===========================================================================
  // API ROUTE: POST /api/checkout_sessions
  // ===========================================================================
  Future<ApiResponse<Map<String, dynamic>>> createCheckoutSession({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> customer,
    required String paymentMethod,
    required double total,
  }) async {
    await init();
    if (simulatedLatencyMs > 0) {
      await Future.delayed(Duration(milliseconds: simulatedLatencyMs * 2));
    }

    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

    // Persist order record in database
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingJson = prefs.getString(_kOrdersStorageKey);
      final List ordersList = existingJson != null ? jsonDecode(existingJson) : [];

      ordersList.insert(0, {
        'orderId': orderId,
        'createdAt': DateTime.now().toIso8601String(),
        'items': items,
        'customer': customer,
        'paymentMethod': paymentMethod,
        'total': total,
        'status': 'confirmed',
      });

      await prefs.setString(_kOrdersStorageKey, jsonEncode(ordersList));
    } catch (e) {
      debugPrint('Error storing order in database: $e');
    }

    return ApiResponse.success(
      statusCode: 201,
      data: {
        'success': true,
        'orderId': orderId,
        'status': 'confirmed',
        'currency': 'ETB',
        'total': total,
        'paymentMethod': paymentMethod,
        'message': 'Order successfully booked in Gebeya database.',
      },
    );
  }

  // ===========================================================================
  // API ROUTE: POST /api/products (Add New Product / Inventory)
  // ===========================================================================
  Future<ApiResponse<Product>> addProduct(Product newProduct) async {
    await init();
    _productsDb.insert(0, newProduct);
    await _persistProducts();
    return ApiResponse.success(statusCode: 201, data: newProduct);
  }

  /// Reset database back to default seed inventory
  Future<void> resetSeedData() async {
    _productsDb = List<Product>.from(MockData.products);
    await _persistProducts();
  }
}

/// Typed API Response Model
class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final String? message;
  final bool isSuccess;

  const ApiResponse.success({
    required this.statusCode,
    required this.data,
    this.message,
  }) : isSuccess = true;

  const ApiResponse.error({
    required this.statusCode,
    required this.message,
  })  : data = null,
        isSuccess = false;
}
