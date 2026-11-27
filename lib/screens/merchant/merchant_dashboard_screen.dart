import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/order.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../profile/order_detail_screen.dart';
import '../profile/widgets/digital_tax_receipt_dialog.dart';
import 'widgets/add_product_modal.dart';

class MerchantDashboardScreen extends StatefulWidget {
  const MerchantDashboardScreen({super.key});

  static void show(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.currentUser?.role != UserRole.merchant) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Merchant account required to open Store Operations.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MerchantDashboardScreen()),
    );
  }

  @override
  State<MerchantDashboardScreen> createState() => _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends State<MerchantDashboardScreen> {
  final NumberFormat _currencyFormat = NumberFormat('#,##0.00');
  OrderStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.currentUser?.role != UserRole.merchant) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline_rounded, size: 64, color: AppColors.error),
                SizedBox(height: 16),
                Text(
                  'Merchant Authorization Required',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'This section is restricted to registered merchant partners. Sign in with a merchant account to manage store operations.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeAccent = isDark ? AppColors.gold : AppColors.primary;
    final onActiveAccent = isDark ? AppColors.onGold : AppColors.goldLight;
    final orderProvider = context.watch<OrderProvider>();
    final allOrders = orderProvider.orders;

    final filteredOrders = _filterStatus == null
        ? allOrders
        : allOrders.where((o) => o.status == _filterStatus).toList();

    // Financial Metrics
    final double totalRevenue = allOrders.fold(0.0, (sum, o) => sum + o.total);
    final int pendingVerificationCount =
        allOrders.where((o) => o.status == OrderStatus.pending).length;
    final int activeOrdersCount = allOrders
        .where((o) =>
            o.status == OrderStatus.confirmed ||
            o.status == OrderStatus.processing ||
            o.status == OrderStatus.shipped)
        .length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded, color: AppColors.accent, size: 22),
            SizedBox(width: 8),
            Text('Merchant Operations'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Add Inventory Item',
            onPressed: () => AddProductModal.show(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue & Metrics Overview
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? const [
                          Color(0xFF10241D),
                          Color(0xFF08120F),
                        ]
                      : const [
                          AppColors.primary,
                          AppColors.primaryDark,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? const Color(0xFF030806) : AppColors.primary)
                        .withValues(alpha: isDark ? 0.55 : 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Store Gross Sales',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'LIVE METRICS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_currencyFormat.format(totalRevenue)} ETB',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildMetricTile(
                        'Pending Review',
                        '$pendingVerificationCount',
                        AppColors.accent,
                      ),
                      const SizedBox(width: 12),
                      _buildMetricTile(
                        'Active Orders',
                        '$activeOrdersCount',
                        Colors.white,
                      ),
                      const SizedBox(width: 12),
                      _buildMetricTile(
                        'Total Orders',
                        '${allOrders.length}',
                        Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Order status filter pills
            const Text(
              'Filter Customer Orders',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(null, 'All Orders (${allOrders.length})'),
                  const SizedBox(width: 8),
                  _filterChip(OrderStatus.pending, 'Pending ($pendingVerificationCount)'),
                  const SizedBox(width: 8),
                  _filterChip(OrderStatus.confirmed, 'Confirmed'),
                  const SizedBox(width: 8),
                  _filterChip(OrderStatus.processing, 'Processing'),
                  const SizedBox(width: 8),
                  _filterChip(OrderStatus.shipped, 'Out for Delivery'),
                  const SizedBox(width: 8),
                  _filterChip(OrderStatus.delivered, 'Delivered'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Orders List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orders (${filteredOrders.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Tap to manage dispatch',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (filteredOrders.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 40,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No orders in this category',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildMerchantOrderCard(
                    context,
                    filteredOrders[index],
                    isDark,
                    activeAccent,
                    onActiveAccent,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(OrderStatus? status, String label) {
    final isSelected = _filterStatus == status;
    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (_) {
        setState(() => _filterStatus = status);
      },
    );
  }

  Widget _buildMerchantOrderCard(
    BuildContext context,
    OrderModel order,
    bool isDark,
    Color activeAccent,
    Color onActiveAccent,
  ) {
    final orderProvider = context.read<OrderProvider>();

    Color statusColor;
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = AppColors.accentDark;
        break;
      case OrderStatus.confirmed:
        statusColor = activeAccent;
        break;
      case OrderStatus.processing:
        statusColor = AppColors.info;
        break;
      case OrderStatus.shipped:
        statusColor = const Color(0xFFA78BFA);
        break;
      case OrderStatus.delivered:
        statusColor = AppColors.success;
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  order.statusDisplay,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Customer & Location info
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${order.shippingAddress.fullName} • ${order.shippingAddress.phoneNumber}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${order.shippingAddress.streetAddress}, ${order.shippingAddress.subcity}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Payment Transfer Verification Information
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  order.paymentMethod == PaymentMethodType.telebirr
                      ? Icons.phone_android_rounded
                      : order.paymentMethod == PaymentMethodType.cbeBirr
                          ? Icons.account_balance_rounded
                          : Icons.payment_rounded,
                  size: 18,
                  color: activeAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Method: ${order.paymentMethodDisplay}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      if (order.paymentTransactionId != null)
                        Text(
                          'Transaction Ref: ${order.paymentTransactionId}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: activeAccent,
                          ),
                        ),
                      if (order.paymentProofNote != null && order.paymentProofNote!.isNotEmpty)
                        Text(
                          'Note: ${order.paymentProofNote}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${_currencyFormat.format(order.total)} ETB',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Merchant Control Actions
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // View Full Details
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailScreen(order: order),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded, size: 16),
                      label: const Text('View Order'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    ),
                    // Direct WhatsApp Invoice Share button
                    ElevatedButton.icon(
                      onPressed: () {
                        DigitalTaxReceiptDialog.show(context, order);
                      },
                      icon: const Icon(Icons.chat_rounded, size: 16),
                      label: const Text('Share Invoice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    ),
                  ],
                ),

                // Change Dispatch Status Dropdown
                PopupMenuButton<OrderStatus>(
                  initialValue: order.status,
                  onSelected: (newStatus) async {
                    await orderProvider.updateOrderStatus(order.id, newStatus);
                    final statusLabel = switch (newStatus) {
                      OrderStatus.pending => 'Pending Verification',
                      OrderStatus.confirmed => 'Confirmed',
                      OrderStatus.processing => 'Processing',
                      OrderStatus.shipped => 'On the Way',
                      OrderStatus.delivered => 'Delivered',
                      OrderStatus.cancelled => 'Cancelled',
                    };
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order #${order.id} marked as $statusLabel.'),
                          duration: const Duration(milliseconds: 1400),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: OrderStatus.confirmed,
                      child: Text('Mark as Confirmed'),
                    ),
                    const PopupMenuItem(
                      value: OrderStatus.processing,
                      child: Text('Mark as Processing'),
                    ),
                    const PopupMenuItem(
                      value: OrderStatus.shipped,
                      child: Text('Mark as On the Way'),
                    ),
                    const PopupMenuItem(
                      value: OrderStatus.delivered,
                      child: Text('Mark as Delivered'),
                    ),
                    const PopupMenuItem(
                      value: OrderStatus.cancelled,
                      child: Text('Cancel Order'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: activeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Change Status',
                          style: TextStyle(
                            color: onActiveAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, color: onActiveAccent, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
