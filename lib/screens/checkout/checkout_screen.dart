import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/order.dart';
import '../../models/shipping_address.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/api_service.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(text: 'Abebe Kebede');
  final TextEditingController _phoneController =
      TextEditingController(text: '+251 91 123 4567');
  final TextEditingController _streetController =
      TextEditingController(text: 'Bole Medhanialem, Olympia St.');
  final TextEditingController _cityController =
      TextEditingController(text: 'Addis Ababa');

  String _selectedSubcity = 'Bole';
  final List<String> _subcities = [
    'Bole',
    'Kazanchis',
    'Kirkos',
    'Lideta',
    'Yeka',
    'Arada',
    'Gulele',
    'Akaki-Kality',
    'Nifas Silk-Lafto',
    'Kolfe Keranio',
  ];

  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.telebirr;
  bool _isExpressDelivery = false;
  bool _isPlacingOrder = false;

  final NumberFormat _currencyFormat = NumberFormat('#,##0.00');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    // Call API Checkout Session (Next.js / Stripe backend)
    final lineItems = cart.itemList
        .map((ci) => {
              'id': ci.product.id,
              'name': ci.product.name,
              'quantity': ci.quantity,
              'unit_amount': (ci.product.price * 100).toInt(),
              'selectedColor': ci.selectedColor,
              'selectedSize': ci.selectedSize,
            })
        .toList();

    await ApiService().createCheckoutSession(
      lineItems: lineItems,
      customerEmail: 'customer@gebeya.et',
      paymentMethod: _selectedPaymentMethod.name,
    );

    if (!mounted) return;

    final shippingAddress = ShippingAddress(
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      streetAddress: _streetController.text.trim(),
      city: _cityController.text.trim(),
      subcity: _selectedSubcity,
    );

    final shippingFee = cart.shippingFee + (_isExpressDelivery ? 100.0 : 0.0);
    final total = (cart.subtotal - cart.discountAmount) +
        shippingFee +
        cart.taxAmount;

    final newOrder = await context.read<OrderProvider>().placeOrder(
          items: cart.itemList,
          subtotal: cart.subtotal,
          discount: cart.discountAmount,
          shippingFee: shippingFee,
          tax: cart.taxAmount,
          total: total,
          shippingAddress: shippingAddress,
          paymentMethod: _selectedPaymentMethod,
        );

    // Clear cart
    cart.clearCart();

    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(order: newOrder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartProvider>();

    final extraExpressFee = _isExpressDelivery ? 100.0 : 0.0;
    final finalShipping = cart.shippingFee + extraExpressFee;
    final finalTotal =
        (cart.subtotal - cart.discountAmount) + finalShipping + cart.taxAmount;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      bottomNavigationBar: _buildBottomBar(context, finalTotal, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Delivery Address Card
              _buildSectionHeader('1. Delivery Address', Icons.location_on_outlined),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Please enter phone' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedSubcity,
                      decoration: const InputDecoration(
                        labelText: 'Subcity / Area',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      items: _subcities.map((sc) {
                        return DropdownMenuItem(value: sc, child: Text(sc));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSubcity = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        labelText: 'Street Address & Landmark',
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Please enter street address'
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. Delivery Options
              _buildSectionHeader('2. Delivery Speed', Icons.local_shipping_outlined),
              const SizedBox(height: 12),
              Material(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isExpressDelivery = false),
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: _isExpressDelivery,
                        onChanged: (val) =>
                            setState(() => _isExpressDelivery = val ?? false),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: const Text(
                          'Standard Delivery (1-2 Days)',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        subtitle: Text(
                          cart.shippingFee == 0
                              ? 'Free Delivery (orders over 5,000 ETB)'
                              : '150.00 ETB flat rate',
                        ),
                        activeColor:
                            isDark ? AppColors.primaryLight : AppColors.primary,
                      ),
                    ),
                    const Divider(height: 1),
                    InkWell(
                      onTap: () => setState(() => _isExpressDelivery = true),
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: _isExpressDelivery,
                        onChanged: (val) =>
                            setState(() => _isExpressDelivery = val ?? true),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: const Text(
                          'Same-Day Express Dispatch (Addis Ababa)',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        subtitle: const Text('+100.00 ETB priority dispatch fee'),
                        activeColor:
                            isDark ? AppColors.primaryLight : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Payment Method
              _buildSectionHeader('3. Payment Method', Icons.payment_outlined),
              const SizedBox(height: 12),
              Material(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildPaymentTile(
                      PaymentMethodType.telebirr,
                      'Telebirr (Ethio Telecom)',
                      'Instant payment via Telebirr SuperApp',
                      Icons.phone_android_rounded,
                      AppColors.telebirr,
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildPaymentTile(
                      PaymentMethodType.cbeBirr,
                      'CBE Birr',
                      'Commercial Bank of Ethiopia Mobile Banking',
                      Icons.account_balance_rounded,
                      AppColors.cbeBirr,
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildPaymentTile(
                      PaymentMethodType.chapa,
                      'Chapa Payment Gateway',
                      'Cards, Ethiopian bank transfers & digital wallets',
                      Icons.bolt_rounded,
                      AppColors.chapa,
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildPaymentTile(
                      PaymentMethodType.stripe,
                      'Credit / Debit Card (Stripe)',
                      'Visa, MasterCard, American Express',
                      Icons.credit_card_rounded,
                      AppColors.stripe,
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildPaymentTile(
                      PaymentMethodType.cashOnDelivery,
                      'Cash on Delivery',
                      'Pay securely in cash upon physical receipt',
                      Icons.handshake_outlined,
                      AppColors.primary,
                      isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 4. Order Summary Preview
              _buildSectionHeader('4. Order Summary', Icons.receipt_long_outlined),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Items (${cart.itemCount})'),
                        Text('${_currencyFormat.format(cart.subtotal)} ETB'),
                      ],
                    ),
                    if (cart.discountAmount > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Discount',
                            style: TextStyle(color: AppColors.success),
                          ),
                          Text(
                            '-${_currencyFormat.format(cart.discountAmount)} ETB',
                            style: const TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shipping & Handling'),
                        Text(
                          finalShipping == 0
                              ? 'FREE'
                              : '${_currencyFormat.format(finalShipping)} ETB',
                          style: TextStyle(
                            color: finalShipping == 0 ? AppColors.success : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('VAT (15%)'),
                        Text('${_currencyFormat.format(cart.taxAmount)} ETB'),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total to Pay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${_currencyFormat.format(finalTotal)} ETB',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? AppColors.primaryLight
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTile(
    PaymentMethodType method,
    String title,
    String subtitle,
    IconData icon,
    Color brandColor,
    bool isDark,
  ) {
    final isSelected = _selectedPaymentMethod == method;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = method),
      child: RadioListTile<PaymentMethodType>(
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (val) {
          if (val != null) setState(() => _selectedPaymentMethod = val);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        activeColor: isDark ? AppColors.primaryLight : AppColors.primary,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: brandColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: brandColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double total, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grand Total',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  '${_currencyFormat.format(total)} ETB',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: _isPlacingOrder ? null : _handlePlaceOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isPlacingOrder
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text('Place Order Now'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
