import '../models/category.dart';
import '../models/product.dart';
import 'local_api_server.dart';

/// Gebeya Client API Service
///
/// Communicates directly with the internal Gebeya API engine.
/// Completely standalone and self-contained with zero external/remote dependencies.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final LocalApiServer _server = LocalApiServer();

  Future<void> init() async {
    await _server.init();
  }

  /// GET /api/products
  Future<List<Product>> fetchProducts({String? category, String? search}) async {
    final response = await _server.getProducts(category: category, search: search);
    return response.data ?? [];
  }

  /// GET /api/products/:id
  Future<Product?> fetchProductById(String id) async {
    final response = await _server.getProductById(id);
    return response.data;
  }

  /// GET /api/categories
  Future<List<ProductCategory>> fetchCategories() async {
    final response = await _server.getCategories();
    return response.data ?? [];
  }

  /// POST /api/checkout_sessions
  Future<Map<String, dynamic>> createCheckoutSession({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> customer,
    required String paymentMethod,
    required double total,
  }) async {
    final response = await _server.createCheckoutSession(
      items: items,
      customer: customer,
      paymentMethod: paymentMethod,
      total: total,
    );
    return response.data ?? {'success': false};
  }

  /// POST /api/products (Add product)
  Future<Product?> addProduct(Product product) async {
    final response = await _server.addProduct(product);
    return response.data;
  }
}
