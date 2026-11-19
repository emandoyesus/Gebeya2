import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  static const String _cartStorageKey = 'gebeya_cart_items_v1';
  final Map<String, CartItem> _items = {};

  String? _couponCode;
  double _couponDiscountPercentage = 0.0;
  double _couponFixedDiscount = 0.0;

  Map<String, CartItem> get items => {..._items};

  List<CartItem> get itemList => _items.values.toList();

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  int get distinctCount => _items.length;

  bool get isEmpty => _items.isEmpty;

  String? get couponCode => _couponCode;
  double get couponDiscountPercentage => _couponDiscountPercentage;

  CartProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJsonString = prefs.getString(_cartStorageKey);
      if (cartJsonString != null && cartJsonString.isNotEmpty) {
        final List<dynamic> decoded = json.decode(cartJsonString);
        _items.clear();
        for (var element in decoded) {
          final item = CartItem.fromJson(element as Map<String, dynamic>);
          _items[item.cartItemId] = item;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart from storage: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _items.values.map((item) => item.toJson()).toList();
      await prefs.setString(_cartStorageKey, json.encode(data));
    } catch (e) {
      debugPrint('Error saving cart to storage: $e');
    }
  }

  void addItem(
    Product product, {
    int quantity = 1,
    String? selectedColor,
    String? selectedSize,
  }) {
    final tempItem = CartItem(
      product: product,
      quantity: quantity,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
    );
    final key = tempItem.cartItemId;

    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = tempItem;
    }

    notifyListeners();
    _saveToStorage();
  }

  void removeItem(String cartItemId) {
    if (_items.containsKey(cartItemId)) {
      _items.remove(cartItemId);
      notifyListeners();
      _saveToStorage();
    }
  }

  void decreaseQuantity(String cartItemId) {
    if (!_items.containsKey(cartItemId)) return;

    if (_items[cartItemId]!.quantity > 1) {
      _items[cartItemId]!.quantity -= 1;
    } else {
      _items.remove(cartItemId);
    }

    notifyListeners();
    _saveToStorage();
  }

  void increaseQuantity(String cartItemId) {
    if (!_items.containsKey(cartItemId)) return;
    _items[cartItemId]!.quantity += 1;
    notifyListeners();
    _saveToStorage();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (!_items.containsKey(cartItemId)) return;
    if (newQuantity <= 0) {
      _items.remove(cartItemId);
    } else {
      _items[cartItemId]!.quantity = newQuantity;
    }
    notifyListeners();
    _saveToStorage();
  }

  void clearCart() {
    _items.clear();
    _couponCode = null;
    _couponDiscountPercentage = 0.0;
    _couponFixedDiscount = 0.0;
    notifyListeners();
    _saveToStorage();
  }

  // Coupon Logic
  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'GEBEYA10') {
      _couponCode = cleanCode;
      _couponDiscountPercentage = 0.10;
      _couponFixedDiscount = 0.0;
      notifyListeners();
      return true;
    } else if (cleanCode == 'WELCOME20') {
      _couponCode = cleanCode;
      _couponDiscountPercentage = 0.20;
      _couponFixedDiscount = 0.0;
      notifyListeners();
      return true;
    } else if (cleanCode == 'HABESHA50') {
      _couponCode = cleanCode;
      _couponDiscountPercentage = 0.0;
      _couponFixedDiscount = 50.0;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _couponCode = null;
    _couponDiscountPercentage = 0.0;
    _couponFixedDiscount = 0.0;
    notifyListeners();
  }

  // Cost calculations
  double get subtotal {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get discountAmount {
    if (subtotal == 0) return 0.0;
    if (_couponDiscountPercentage > 0) {
      return subtotal * _couponDiscountPercentage;
    }
    if (_couponFixedDiscount > 0) {
      return _couponFixedDiscount > subtotal ? subtotal : _couponFixedDiscount;
    }
    return 0.0;
  }

  double get shippingFee {
    if (subtotal == 0) return 0.0;
    // Free shipping over 5000 ETB
    return subtotal > 5000.0 ? 0.0 : 150.0;
  }

  double get taxAmount {
    if (subtotal == 0) return 0.0;
    // 15% Ethiopian standard VAT applied to discounted subtotal
    final taxable = (subtotal - discountAmount);
    return taxable * 0.15;
  }

  double get grandTotal {
    if (subtotal == 0) return 0.0;
    final total = (subtotal - discountAmount) + shippingFee + taxAmount;
    return total > 0 ? total : 0.0;
  }
}
