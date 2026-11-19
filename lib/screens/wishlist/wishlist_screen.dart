import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  final Function(int tabIndex)? onNavigateTab;

  const WishlistScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wishlist = context.watch<WishlistProvider>();
    final favorites = wishlist.favorites;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('My Wishlist'),
            if (favorites.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${favorites.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (favorites.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                final cart = context.read<CartProvider>();
                for (var p in favorites) {
                  cart.addItem(p);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Moved ${favorites.length} items to cart! 🛍️'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: const Text('Add All to Cart'),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? EmptyStateWidget(
              icon: Icons.favorite_border_rounded,
              title: 'Your wishlist is empty',
              subtitle:
                  'Save items you love by tapping the heart icon on any product. They\'ll show up right here.',
              buttonText: 'Explore Collection',
              onButtonPressed: () {
                onNavigateTab?.call(0); // Navigate to Home
              },
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: favorites[index]);
              },
            ),
    );
  }
}
