import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;
  final bool isLarge;
  final String currency;

  const PriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 16,
    this.isLarge = false,
    this.currency = 'ETB',
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    final formattedPrice = formatter.format(price);
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$formattedPrice $currency',
          style: TextStyle(
            fontSize: isLarge ? fontSize * 1.3 : fontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.3,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            '${formatter.format(originalPrice!)} $currency',
            style: TextStyle(
              fontSize: (isLarge ? fontSize * 1.3 : fontSize) * 0.75,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextMuted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}
