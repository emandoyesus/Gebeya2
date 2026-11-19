import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  static const String _wishlistStorageKey = 'gebeya_wishlist_items_v1';
  final Map<String, Product> _favoriteProducts = {};

  List<Product> get favorites => _favoriteProducts.values.toList();
  int get count => _favoriteProducts.length;
  bool get isEmpty => _favoriteProducts.isEmpty;

  WishlistProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_wishlistStorageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = json.decode(jsonString);
        _favoriteProducts.clear();
        for (var item in decoded) {
          final product = Product.fromJson(item as Map<String, dynamic>);
          _favoriteProducts[product.id] = product;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _favoriteProducts.values.map((p) => p.toJson()).toList();
      await prefs.setString(_wishlistStorageKey, json.encode(data));
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.containsKey(productId);
  }

  void toggleFavorite(Product product) {
    if (_favoriteProducts.containsKey(product.id)) {
      _favoriteProducts.remove(product.id);
    } else {
      _favoriteProducts[product.id] = product;
    }
    notifyListeners();
    _saveToStorage();
  }

  void removeFromWishlist(String productId) {
    if (_favoriteProducts.containsKey(productId)) {
      _favoriteProducts.remove(productId);
      notifyListeners();
      _saveToStorage();
    }
  }

  void clearWishlist() {
    _favoriteProducts.clear();
    notifyListeners();
    _saveToStorage();
  }
}
