import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading orders: $e');
      notifyListeners();
    }
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
    String? paymentTransactionId,
    String? paymentProofNote,
  }) async {
    final now = DateTime.now();
    final randomId = 'GEB-${(100000 + (now.millisecondsSinceEpoch % 900000))}';

    // Orders requiring manual transfer verification (Telebirr/CBE Birr) start as pending or confirmed
    final initialStatus = (paymentMethod == PaymentMethodType.telebirr ||
            paymentMethod == PaymentMethodType.cbeBirr)
        ? (paymentTransactionId != null && paymentTransactionId.isNotEmpty
            ? OrderStatus.confirmed
            : OrderStatus.pending)
        : OrderStatus.confirmed;

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
      status: initialStatus,
      createdAt: now,
      estimatedDelivery: now.add(const Duration(days: 2)),
      paymentTransactionId: paymentTransactionId,
      paymentProofNote: paymentProofNote,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    await _saveToStorage();
    return newOrder;
  }

  /// Merchant Action: Update Order Status (Confirmed -> Processing -> On the Way -> Delivered)
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
      await _saveToStorage();
    }
  }

  /// Merchant Action: Verify Payment
  Future<void> verifyPayment(String orderId, {String? notes}) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: OrderStatus.confirmed,
        paymentProofNote: notes ?? 'Payment verified by merchant',
      );
      notifyListeners();
      await _saveToStorage();
    }
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
