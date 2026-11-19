import 'package:flutter_test/flutter_test.dart';
import 'package:gebeya/data/mock_data.dart';
import 'package:gebeya/models/cart_item.dart';
import 'package:gebeya/providers/cart_provider.dart';

void main() {
  group('Gebeya Core Logic Tests', () {
    test('Mock products load with valid categories', () {
      expect(MockData.products.isNotEmpty, true);
      expect(MockData.categories.isNotEmpty, true);

      final yirgacheffe = MockData.products.firstWhere((p) => p.id == 'gebeya_02');
      expect(yirgacheffe.name.contains('Yirgacheffe'), true);
      expect(yirgacheffe.category, 'ethiopian_heritage');
      expect(yirgacheffe.hasDiscount, true);
      expect(yirgacheffe.discountPercentage, greaterThan(0));
    });

    test('CartItem calculates total price correctly', () {
      final product = MockData.products.first;
      final cartItem = CartItem(product: product, quantity: 3);

      expect(cartItem.totalPrice, product.price * 3);
      expect(cartItem.cartItemId, contains(product.id));
    });

    test('Promo codes apply discounts accurately', () {
      final cart = CartProvider();
      final product = MockData.products.first; // price 4950
      cart.addItem(product, quantity: 2); // 9900

      expect(cart.subtotal, 9900.0);

      // Apply 10% coupon
      final applied = cart.applyCoupon('GEBEYA10');
      expect(applied, true);
      expect(cart.discountAmount, 990.0);
      expect(cart.couponDiscountPercentage, 0.10);

      cart.removeCoupon();
      expect(cart.discountAmount, 0.0);
    });
  });
}
