import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../models/order.dart';

class DigitalTaxReceiptDialog extends StatelessWidget {
  final OrderModel order;

  const DigitalTaxReceiptDialog({super.key, required this.order});

  static void show(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (_) => DigitalTaxReceiptDialog(order: order),
    );
  }

  String _generatePlainTextReceipt() {
    final currency = NumberFormat('#,##0.00');
    final date = DateFormat('yyyy-MM-dd HH:mm:ss').format(order.createdAt);

    final sb = StringBuffer();
    sb.writeln('====================================');
    sb.writeln('          GEBEYA • ገበያ          ');
    sb.writeln('   ETHIOPIAN OFFICIAL SALES INVOICE ');
    sb.writeln('====================================');
    sb.writeln('Merchant: Gebeya Commercial PLC');
    sb.writeln('TIN: 0048291048  |  TOT/VAT Reg: 15%');
    sb.writeln('Addis Ababa, Ethiopia | Tel: +251 91 100 2233');
    sb.writeln('------------------------------------');
    sb.writeln('Order Number: ${order.id}');
    sb.writeln('Date & Time:  $date');
    sb.writeln('Customer:     ${order.shippingAddress.fullName}');
    sb.writeln('Phone:        ${order.shippingAddress.phoneNumber}');
    sb.writeln('Address:      ${order.shippingAddress.streetAddress}, ${order.shippingAddress.subcity}');
    sb.writeln('------------------------------------');
    sb.writeln('ITEMS:');
    for (var item in order.items) {
      sb.writeln('- ${item.product.name} (x${item.quantity})');
      if (item.selectedSize != null || item.selectedColor != null) {
        sb.writeln('  Variant: ${item.selectedSize ?? ""} ${item.selectedColor ?? ""}');
      }
      sb.writeln('  Price: ${currency.format(item.totalPrice)} ETB');
    }
    sb.writeln('------------------------------------');
    sb.writeln('Subtotal:      ${currency.format(order.subtotal)} ETB');
    if (order.discount > 0) {
      sb.writeln('Discount:     -${currency.format(order.discount)} ETB');
    }
    sb.writeln('Delivery Fee:  ${currency.format(order.shippingFee)} ETB');
    sb.writeln('VAT (15%):     ${currency.format(order.tax)} ETB');
    sb.writeln('TOTAL PAID:    ${currency.format(order.total)} ETB');
    sb.writeln('Payment:       ${order.paymentMethodDisplay}');
    if (order.paymentTransactionId != null) {
      sb.writeln('Txn Ref:       ${order.paymentTransactionId}');
    }
    sb.writeln('====================================');
    sb.writeln('Thank you for shopping on Gebeya!');
    sb.writeln('Delivery Inquiries: support@gebeya.et');
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeAccent = isDark ? AppColors.gold : AppColors.primary;
    final currency = NumberFormat('#,##0.00');
    final date = DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: activeAccent.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: activeAccent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tax Sales Invoice',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'የሽያጭ ደረሰኝ (15% VAT Included)',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Digital Watermarked Invoice Paper Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Merchant Header
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Gebeya',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: activeAccent,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'ገበያ',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.onGold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Gebeya Commercial PLC • Addis Ababa',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'TIN: 0048291048 • VAT/TOT Reg: 15%',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 20),

                    // Order Info
                    _buildInvoiceRow('Invoice Number', order.id, isBold: true, isDark: isDark),
                    _buildInvoiceRow('Date & Time', date, isDark: isDark),
                    _buildInvoiceRow('Payment Method', order.paymentMethodDisplay, isDark: isDark),
                    if (order.paymentTransactionId != null)
                      _buildInvoiceRow(
                        'Transaction Ref',
                        order.paymentTransactionId!,
                        valueColor: activeAccent,
                        isDark: isDark,
                      ),

                    const Divider(height: 16),

                    // Customer Details
                    _buildInvoiceRow('Customer', order.shippingAddress.fullName, isDark: isDark),
                    _buildInvoiceRow('Phone', order.shippingAddress.phoneNumber, isDark: isDark),
                    _buildInvoiceRow('Dispatch Area', '${order.shippingAddress.streetAddress}, ${order.shippingAddress.subcity}', isDark: isDark),

                    const Divider(height: 16),

                    // Items List
                    Text(
                      'PURCHASED ITEMS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...order.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.quantity}x ',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                  if (item.selectedSize != null || item.selectedColor != null)
                                    Text(
                                      '${item.selectedSize ?? ""} ${item.selectedColor ?? ""}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '${currency.format(item.totalPrice)} ETB',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      );
                    }),

                    const Divider(height: 16),

                    // Breakdown
                    _buildInvoiceRow('Subtotal', '${currency.format(order.subtotal)} ETB', isDark: isDark),
                    if (order.discount > 0)
                      _buildInvoiceRow(
                        'Promotional Discount',
                        '-${currency.format(order.discount)} ETB',
                        valueColor: AppColors.success,
                        isDark: isDark,
                      ),
                    _buildInvoiceRow(
                      'Delivery Fee',
                      order.shippingFee == 0 ? 'FREE' : '${currency.format(order.shippingFee)} ETB',
                      isDark: isDark,
                    ),
                    _buildInvoiceRow('VAT (15%)', '${currency.format(order.tax)} ETB', isDark: isDark),

                    const Divider(height: 16),

                    // Grand Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL AMOUNT PAID',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          '${currency.format(order.total)} ETB',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: activeAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Action Buttons: Share / Copy
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Copy Invoice Text', style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        final text = _generatePlainTextReceipt();
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tax invoice copied to clipboard!'),
                            duration: Duration(milliseconds: 1400),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.chat_rounded, size: 16),
                      label: const Text('Send to WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      onPressed: () {
                        final text = _generatePlainTextReceipt();
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invoice copied. Paste it into WhatsApp to share.'),
                            backgroundColor: Color(0xFF25D366),
                            duration: Duration(milliseconds: 2200),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
