import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/details/product_detail_screen.dart';
import 'app_image.dart';
import 'price_tag.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final String? heroTag;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wishlistProvider = context.watch<WishlistProvider>();
    final isFav = wishlistProvider.isFavorite(product.id);
    final effectiveHeroTag = heroTag ?? 'prod_hero_${product.id}';

    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  productId: product.id,
                  heroTag: effectiveHeroTag,
                ),
              ),
            );
          },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1.25,
                    child: Hero(
                      tag: effectiveHeroTag,
                      child: AppImage(
                        imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),

                // Discount Badge
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${product.discountPercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                // Wishlist Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.read<WishlistProvider>().toggleFavorite(product);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFav
                                  ? 'Removed from wishlist'
                                  : 'Added to wishlist ❤️',
                            ),
                            duration: const Duration(milliseconds: 1200),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.primaryDark.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 17,
                            color: isFav ? AppColors.error : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextMuted),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating & Reviews
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: isDark ? AppColors.sandDune : AppColors.primary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.sandDune : AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '(${product.reviewCount})',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Title
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),

                    // Price & Add to Cart Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: PriceTag(
                            price: product.price,
                            originalPrice: product.originalPrice,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            color: isDark ? AppColors.sandDune : AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                context.read<CartProvider>().addItem(product);
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added ${product.name} to cart! 🛍️'),
                                    duration: const Duration(milliseconds: 2200),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'View Cart',
                                      textColor: isDark ? AppColors.primary : AppColors.sandDune,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: isDark ? AppColors.primary : AppColors.sandDune,
                                  size: 19,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
