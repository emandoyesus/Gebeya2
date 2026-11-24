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
    this.fontSize = 14,
    this.isLarge = false,
    this.currency = 'ETB',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.00');
    final formattedPrice = formatter.format(price);
    final hasDiscount = originalPrice != null && originalPrice! > price;

    if (isLarge) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          Text(
            '$formattedPrice $currency',
            style: TextStyle(
              fontSize: fontSize * 1.3,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.gold : AppColors.black,
              letterSpacing: -0.3,
            ),
          ),
          if (hasDiscount)
            Text(
              '${formatter.format(originalPrice!)} $currency',
              style: TextStyle(
                fontSize: fontSize * 0.9,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$formattedPrice $currency',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.gold : AppColors.black,
            letterSpacing: -0.3,
          ),
        ),
        if (hasDiscount)
          Text(
            '${formatter.format(originalPrice!)} $currency',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize * 0.75,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
