import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/shipping_address.dart';

class OrderProvider extends ChangeNotifier {
  static const String _ordersStorageKey = 'gebeya_orders_v1';
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  OrderProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_ordersStorageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = json.decode(jsonString);
        _orders.clear();
        for (var item in decoded) {
          _orders.add(OrderModel.fromJson(item as Map<String, dynamic>));
        }
      } else {
        // Pre-populate with a demo order for rich UI experience
        _addDemoOrder();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading orders: $e');
      _addDemoOrder();
      notifyListeners();
    }
  }

  void _addDemoOrder() {
    if (_orders.isNotEmpty) return;
    final demoProduct = MockData.products[1]; // Yirgacheffe Coffee
    _orders.add(
      OrderModel(
        id: 'GEB-892147',
        items: [
          CartItem(
            product: demoProduct,
            quantity: 2,
            selectedSize: 'Whole Bean (1kg)',
          ),
        ],
        subtotal: 3700.0,
        discount: 370.0,
        shippingFee: 0.0,
        tax: 499.5,
        total: 3829.5,
        shippingAddress: const ShippingAddress(
          fullName: 'Abebe Kebede',
          phoneNumber: '+251 91 123 4567',
          streetAddress: 'Bole Medhanialem, Olympia St.',
          city: 'Addis Ababa',
          subcity: 'Bole',
          postalCode: '1000',
        ),
        paymentMethod: PaymentMethodType.telebirr,
        status: OrderStatus.shipped,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
      ),
    );
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _orders.map((o) => o.toJson()).toList();
      await prefs.setString(_ordersStorageKey, json.encode(data));
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }

  Future<OrderModel> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double shippingFee,
    required double tax,
    required double total,
    required ShippingAddress shippingAddress,
    required PaymentMethodType paymentMethod,
  }) async {
    final now = DateTime.now();
    final randomId = 'GEB-${(100000 + (now.millisecondsSinceEpoch % 900000))}';

    final newOrder = OrderModel(
      id: randomId,
      items: List.from(items),
      subtotal: subtotal,
      discount: discount,
      shippingFee: shippingFee,
      tax: tax,
      total: total,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.confirmed,
      createdAt: now,
      estimatedDelivery: now.add(const Duration(days: 2)),
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    await _saveToStorage();
    return newOrder;
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
