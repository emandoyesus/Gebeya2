import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';
import '../models/product.dart';

enum ApiDataSource {
  cloudLive,
  nextJsBackend,
  stripeApi,
  offlineCache,
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Storage keys
  static const String _kCachedProductsKey = 'gebeya_cached_products_v1';
  static const String _kApiDataSourceKey = 'gebeya_api_data_source';
  static const String _kNextJsBaseUrlKey = 'gebeya_nextjs_base_url';
  static const String _kStripeSecretKey = 'gebeya_stripe_secret_key';

  // Default Next.js Base URL
  static String get defaultNextJsBaseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    try {
      if (Platform.isAndroid) {
        // Android emulator maps 10.0.2.2 to host machine's localhost
        return 'http://10.0.2.2:3000';
      }
    } catch (_) {}
    return 'http://localhost:3000';
  }

  // Active configurations
  ApiDataSource _currentSource = ApiDataSource.cloudLive;
  String _nextJsBaseUrl = '';
  String _stripeApiKey = '';

  ApiDataSource get currentSource => _currentSource;
  String get nextJsBaseUrl => _nextJsBaseUrl.isEmpty ? defaultNextJsBaseUrl : _nextJsBaseUrl;
  String get stripeApiKey => _stripeApiKey;

  Future<void> initConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sourceIndex = prefs.getInt(_kApiDataSourceKey);
      if (sourceIndex != null && sourceIndex < ApiDataSource.values.length) {
        _currentSource = ApiDataSource.values[sourceIndex];
      }
      _nextJsBaseUrl = prefs.getString(_kNextJsBaseUrlKey) ?? defaultNextJsBaseUrl;
      _stripeApiKey = prefs.getString(_kStripeSecretKey) ?? '';
    } catch (e) {
      debugPrint('Error loading API configuration: $e');
    }
  }

  Future<void> setDataSource(ApiDataSource source) async {
    _currentSource = source;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kApiDataSourceKey, source.index);
    } catch (e) {
      debugPrint('Error saving API data source: $e');
    }
  }

  Future<void> setNextJsBaseUrl(String url) async {
    _nextJsBaseUrl = url.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kNextJsBaseUrlKey, _nextJsBaseUrl);
    } catch (e) {
      debugPrint('Error saving Next.js Base URL: $e');
    }
  }

  Future<void> setStripeApiKey(String key) async {
    _stripeApiKey = key.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kStripeSecretKey, _stripeApiKey);
    } catch (e) {
      debugPrint('Error saving Stripe API Key: $e');
    }
  }

  /// Main method to fetch products according to current active data source
  Future<List<Product>> fetchProducts() async {
    switch (_currentSource) {
      case ApiDataSource.cloudLive:
        return _fetchFromCloudStore();
      case ApiDataSource.nextJsBackend:
        return _fetchFromNextJs();
      case ApiDataSource.stripeApi:
        return _fetchFromStripe();
      case ApiDataSource.offlineCache:
        return getOfflineCachedProducts();
    }
  }

  /// 1. Cloud Live API: Real e-commerce REST API
  Future<List<Product>> _fetchFromCloudStore() async {
    try {
      final uri = Uri.parse('https://dummyjson.com/products?limit=28');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List items = data['products'] as List;

        final liveProducts = items.map((item) {
          final id = 'live_${item['id']}';
          final title = item['title'] as String;
          final description = item['description'] as String;
          final rawPrice = (item['price'] as num).toDouble();
          // Convert USD price to ETB (~120 ETB per USD) for localized pricing
          final priceInEtb = (rawPrice * 120.0).roundToDouble();
          final discountPct = (item['discountPercentage'] as num?)?.toDouble() ?? 0.0;
          final originalPrice = discountPct > 0
              ? (priceInEtb / (1 - (discountPct / 100))).roundToDouble()
              : null;
          final rating = (item['rating'] as num?)?.toDouble() ?? 4.7;
          final stock = (item['stock'] as num?)?.toInt() ?? 10;
          final categoryRaw = (item['category'] as String?)?.toLowerCase() ?? 'other';

          // Map API category to Gebeya categories
          String category = 'home';
          if (categoryRaw.contains('smartphones') ||
              categoryRaw.contains('laptops') ||
              categoryRaw.contains('tablets') ||
              categoryRaw.contains('electronics') ||
              categoryRaw.contains('mobile')) {
            category = 'electronics';
          } else if (categoryRaw.contains('dresses') ||
              categoryRaw.contains('shirts') ||
              categoryRaw.contains('shoes') ||
              categoryRaw.contains('clothing') ||
              categoryRaw.contains('accessories') ||
              categoryRaw.contains('watches') ||
              categoryRaw.contains('bags')) {
            category = 'fashion';
          } else if (categoryRaw.contains('groceries') ||
              categoryRaw.contains('fragrances') ||
              categoryRaw.contains('beauty') ||
              categoryRaw.contains('skin')) {
            category = 'ethiopian_heritage';
          }

          final List<String> images = [];
          if (item['images'] is List) {
            images.addAll(List<String>.from(item['images']));
          }
          if (images.isEmpty && item['thumbnail'] != null) {
            images.add(item['thumbnail'] as String);
          }

          final isFeatured = (item['id'] as int) % 3 == 0;

          return Product(
            id: id,
            name: title,
            nameAmharic: '',
            description: description,
            price: priceInEtb,
            originalPrice: originalPrice,
            rating: rating,
            reviewCount: (item['stock'] as num? ?? 15).toInt() * 3 + 12,
            imageUrls: images,
            category: category,
            inStock: stock > 0,
            isFeatured: isFeatured,
            availableColors: const ['#0F766E', '#0B132B', '#E2E8F0'],
            availableSizes: category == 'fashion' ? const ['S', 'M', 'L', 'XL'] : const [],
            specifications: {
              'Brand': item['brand']?.toString() ?? 'Gebeya Verified',
              'SKU': item['sku']?.toString() ?? 'GBY-$id',
              'Warranty': item['warrantyInformation']?.toString() ?? '1 Year Standard',
              'Origin': 'Global Import / Gebeya Direct',
            },
          );
        }).toList();

        // Include curated Ethiopian heritage goods to preserve local identity
        final heritageItems = MockData.products
            .where((p) => p.category == 'ethiopian_heritage')
            .toList();
        final combined = [...heritageItems, ...liveProducts];

        // Save to offline cache
        await _saveProductsToCache(combined);
        return combined;
      } else {
        throw Exception('Cloud API returned status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Cloud Live API failed: $e. Falling back to local cache.');
      return getOfflineCachedProducts();
    }
  }

  /// 2. Next.js API Backend: Dan Seng's Next.js eCommerce repo endpoint
  Future<List<Product>> _fetchFromNextJs() async {
    try {
      final url = '${nextJsBaseUrl.replaceAll(RegExp(r'/+$'), '')}/api/products';
      final response = await http
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List rawList = [];
        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          rawList = decoded['data'];
        } else if (decoded is Map && decoded['products'] is List) {
          rawList = decoded['products'];
        }

        final products = rawList.map((item) {
          if (item is Map<String, dynamic>) {
            // Check if it's Stripe product schema from Next.js backend
            if (item.containsKey('default_price') || item.containsKey('images')) {
              return _parseStripeProduct(item);
            }
            return Product.fromJson(item);
          }
          throw Exception('Invalid product schema from Next.js API');
        }).toList();

        if (products.isNotEmpty) {
          await _saveProductsToCache(products);
          return products;
        }
      }
      throw Exception('Next.js API responded with status ${response.statusCode}');
    } catch (e) {
      debugPrint('Next.js API failed ($e). Falling back to offline cache.');
      return getOfflineCachedProducts();
    }
  }

  /// 3. Direct Stripe REST API: https://api.stripe.com/v1/products
  Future<List<Product>> _fetchFromStripe() async {
    if (_stripeApiKey.isEmpty) {
      debugPrint('No Stripe API key configured. Using offline cache.');
      return getOfflineCachedProducts();
    }

    try {
      final uri = Uri.parse('https://api.stripe.com/v1/products?active=true&expand[]=data.default_price&limit=20');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_stripeApiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List list = data['data'] as List;

        final products = list
            .map((item) => _parseStripeProduct(item as Map<String, dynamic>))
            .toList();

        if (products.isNotEmpty) {
          await _saveProductsToCache(products);
          return products;
        }
      }
      throw Exception('Stripe API error: ${response.statusCode} ${response.body}');
    } catch (e) {
      debugPrint('Stripe API failed ($e). Falling back to offline cache.');
      return getOfflineCachedProducts();
    }
  }

  /// Helper to convert Stripe Product Object to Gebeya Product Model
  Product _parseStripeProduct(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final name = json['name'] as String;
    final description = json['description'] as String? ?? 'Quality product verified on Gebeya.';
    final images = List<String>.from(json['images'] ?? []);
    if (images.isEmpty) {
      images.add('https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80');
    }

    double price = 1200.0;
    if (json['default_price'] is Map) {
      final priceObj = json['default_price'] as Map<String, dynamic>;
      final unitAmount = (priceObj['unit_amount'] as num?)?.toDouble() ?? 120000;
      // Stripe prices are in cents
      price = unitAmount / 100.0;
    }

    final metadata = (json['metadata'] as Map?)?.cast<String, dynamic>() ?? {};
    final category = metadata['category'] as String? ?? 'electronics';
    final nameAmharic = metadata['name_amharic'] as String? ?? '';
    final rating = double.tryParse(metadata['rating']?.toString() ?? '') ?? 4.8;
    final isFeatured = metadata['is_featured']?.toString().toLowerCase() == 'true';

    return Product(
      id: id,
      name: name,
      nameAmharic: nameAmharic,
      description: description,
      price: price,
      rating: rating,
      reviewCount: 45,
      imageUrls: images,
      category: category,
      inStock: true,
      isFeatured: isFeatured,
      availableColors: const ['#0F766E', '#0B132B'],
      availableSizes: const [],
      specifications: {
        'Provider': 'Stripe Verified Merchant',
        'Stripe Product ID': id,
      },
    );
  }

  /// Create Checkout Session on Next.js Backend (/api/checkout_sessions)
  Future<Map<String, dynamic>> createCheckoutSession({
    required List<Map<String, dynamic>> lineItems,
    required String customerEmail,
    required String paymentMethod,
  }) async {
    try {
      final url = '${nextJsBaseUrl.replaceAll(RegExp(r'/+$'), '')}/api/checkout_sessions';
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'items': lineItems,
              'customerEmail': customerEmail,
              'paymentMethod': paymentMethod,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Remote checkout session failed ($e). Emulating completed session.');
    }

    // Graceful fallback for local/offline checkout
    return {
      'id': 'cs_gebeya_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'success',
      'url': null,
      'mode': 'local_completed',
    };
  }

  /// Persistent Offline Cache Storage
  Future<void> _saveProductsToCache(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = products.map((p) => p.toJson()).toList();
      await prefs.setString(_kCachedProductsKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Failed to save products to local cache: $e');
    }
  }

  /// Retrieve products from local cache or default mock catalog
  Future<List<Product>> getOfflineCachedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_kCachedProductsKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final List decoded = jsonDecode(cachedJson) as List;
        final list = decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e) {
      debugPrint('Error reading offline cached products: $e');
    }
    // Default fallback to curated MockData
    return List<Product>.from(MockData.products);
  }
}
