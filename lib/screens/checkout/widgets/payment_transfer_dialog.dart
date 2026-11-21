import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_colors.dart';
import '../../../models/order.dart';

class PaymentTransferDialog extends StatefulWidget {
  final PaymentMethodType method;
  final double amount;
  final Function(String transactionId, String notes) onConfirmed;

  const PaymentTransferDialog({
    super.key,
    required this.method,
    required this.amount,
    required this.onConfirmed,
  });

  static Future<bool?> show({
    required BuildContext context,
    required PaymentMethodType method,
    required double amount,
    required Function(String transactionId, String notes) onConfirmed,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentTransferDialog(
        method: method,
        amount: amount,
        onConfirmed: onConfirmed,
      ),
    );
  }

  @override
  State<PaymentTransferDialog> createState() => _PaymentTransferDialogState();
}

class _PaymentTransferDialogState extends State<PaymentTransferDialog> {
  final _txnController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _txnController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTelebirr = widget.method == PaymentMethodType.telebirr;

    final accountName = isTelebirr ? 'GEBEYA E-COMMERCE ENTERPRISE' : 'GEBEYA TRADING PLC';
    final accountNumber = isTelebirr ? '0911002233' : '1000293847291';
    final tillCode = isTelebirr ? '884920' : null;

    final brandColor = isTelebirr ? AppColors.telebirr : AppColors.cbeBirr;
    final brandTitle = isTelebirr ? 'Telebirr Direct Transfer' : 'CBE Birr / Commercial Bank of Ethiopia';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: brandColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isTelebirr ? Icons.phone_android_rounded : Icons.account_balance_rounded,
                      color: brandColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brandTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Zero-Fee Merchant Transfer',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Total to transfer badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: brandColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Exact Amount to Transfer',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.amount.toStringAsFixed(2)} ETB',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: brandColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Merchant account details card with one-tap copy
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 1: Send payment to Merchant',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    _buildCopyRow(context, 'Account Name', accountName),
                    const SizedBox(height: 8),
                    _buildCopyRow(context, isTelebirr ? 'Telebirr Phone' : 'CBE Account Number', accountNumber),
                    if (tillCode != null) ...[
                      const SizedBox(height: 8),
                      _buildCopyRow(context, 'Merchant Till Code', tillCode),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Step 2: Input Transaction reference
              const Text(
                'Step 2: Enter Transaction ID / Reference',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _txnController,
                decoration: InputDecoration(
                  labelText: isTelebirr ? 'Telebirr Txn ID (e.g. TB99824)' : 'CBE Reference (e.g. FT24098...)',
                  hintText: isTelebirr ? 'e.g. TB82937402' : 'e.g. FT260914210',
                  prefixIcon: const Icon(Icons.receipt_long_rounded),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter the transaction reference from SMS';
                  }
                  if (val.trim().length < 4) {
                    return 'Reference is too short';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Sender Name or Phone (Optional note)',
                  hintText: 'e.g. Sent from Abebe phone 0911...',
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onConfirmed(
                            _txnController.text.trim(),
                            _notesController.text.trim(),
                          );
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        'Verify & Confirm',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
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

  Widget _buildCopyRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.copy_rounded, size: 18),
          tooltip: 'Copy $label',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied $value to clipboard!'),
                duration: const Duration(milliseconds: 1200),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }
}
