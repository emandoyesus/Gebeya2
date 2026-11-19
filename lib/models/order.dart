import 'cart_item.dart';
import 'shipping_address.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentMethodType {
  telebirr,
  cbeBirr,
  chapa,
  stripe,
  cashOnDelivery,
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double shippingFee;
  final double tax;
  final double total;
  final ShippingAddress shippingAddress;
  final PaymentMethodType paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime estimatedDelivery;

  const OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.shippingFee,
    required this.tax,
    required this.total,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.confirmed,
    required this.createdAt,
    required this.estimatedDelivery,
  });

  String get statusDisplay {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get paymentMethodDisplay {
    switch (paymentMethod) {
      case PaymentMethodType.telebirr:
        return 'Telebirr';
      case PaymentMethodType.cbeBirr:
        return 'CBE Birr';
      case PaymentMethodType.chapa:
        return 'Chapa';
      case PaymentMethodType.stripe:
        return 'Credit Card (Stripe)';
      case PaymentMethodType.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'shippingFee': shippingFee,
      'tax': tax,
      'total': total,
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod.index,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDelivery': estimatedDelivery.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      shippingAddress: ShippingAddress.fromJson(
          json['shippingAddress'] as Map<String, dynamic>),
      paymentMethod: PaymentMethodType.values[json['paymentMethod'] as int],
      status: OrderStatus.values[json['status'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDelivery: DateTime.parse(json['estimatedDelivery'] as String),
    );
  }
}
